import sys
import boto3
import pyspark.sql.functions as F
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

DATABASE_LANDING = "avujic-academy-aws-landing"
client = boto3.client('glue', region_name='eu-central-1')
response_get_tables = client.get_tables(DatabaseName = DATABASE_LANDING)

for table in response_get_tables["TableList"]:
    table_name = table["Name"]
    
    S3bucket_node1 = glueContext.create_dynamic_frame.from_catalog(
        database=DATABASE_LANDING,
        table_name=table_name,
        transformation_ctx="S3bucket_node1",
    )
    
    spark_df = S3bucket_node1.toDF()
    
    spark_df = spark_df.withColumn("datalake_timestamp", F.current_timestamp())
    spark_df = spark_df.withColumn("datalake_date", F.current_date())
    
    glueContext = GlueContext(SparkContext.getOrCreate())
    df = DynamicFrame.fromDF(spark_df, glueContext, "new_dynamicFrame")
    
    S3bucket_node3 = glueContext.write_dynamic_frame.from_options(
        frame=df,
        connection_type="s3",
        format="glueparquet",
        connection_options={
            "path": f"s3://avujic-academy-aws/imdb/datalake/{table_name}/",
            "partitionKeys": ["datalake_date"],
        },
        format_options={"compression": "snappy"},
        transformation_ctx="S3bucket_node3",
    )
job.commit()