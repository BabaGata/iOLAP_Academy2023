import boto3
import requests
import datetime as dt
import os

dynamo = boto3.client('dynamodb', region_name="eu-central-1")
sns = boto3.client('sns')
s3_resource = boto3.resource('s3')

M_I_D = "?min_ingestion_dttm="
BUCKET_NAME = os.getenv('S3_BUCKET_DATA')
GLOBAL_TN = os.getenv('DYNAMO_GLOBAL')
JOBS_TN = os.getenv('DYNAMO_JOBS')

def getting_global_uri():
    global_config = dynamo.get_item(
        TableName = GLOBAL_TN,
        Key={
            'name': {'S': 'imdb-rest-api'}
        }
    )
    
    METHOD = global_config['Item']['method']['S']
    HOST = global_config['Item']['host']['S']
    PORT = global_config['Item']['port']['S']
    PREFIX = global_config['Item']['prefix']['S']
    
    URL = global_config['Item']['url']['S'].format(method=METHOD, host=HOST, port=PORT, prefix=PREFIX)
    PARTITIONS_URI = global_config['Item']['partitions_uri']['S']
    return URL, PARTITIONS_URI
    
def getting_table_cofiguration(table_name):
    jobs_config = dynamo.get_item(
        TableName=JOBS_TN,
        Key={
            'table_name': {'S': table_name}
        }
    )
        
    return jobs_config['Item']['min_ingestion_dttm']['S'], jobs_config['Item']['uri']['S']
    
def save_partitons(partitions, min_ingestion_dttm, job_table_uri, URL, table_name):
    for partition in partitions.json():
        if check_latest_date(min_ingestion_dttm, dt.datetime.strptime(partition, "%Y%m%dT%H%M%S.%f")):
            partition_r = requests.get(URL + job_table_uri + M_I_D + partition)
            partition_r = partition_r.json()
            
            s3object = s3_resource.Object(BUCKET_NAME, "imdb/landing/" + table_name + "/" + partition + ".json")
            s3object.put(Body = partition_r)
            
def update_min_ingestion_dttm(table_name, latest_partition):
    dynamo.update_item(
        TableName = JOBS_TN,
        Key = {
            "table_name" : {"S" : table_name}
        },
        AttributeUpdates = {
            "min_ingestion_dttm" : {"Value": {"S" : latest_partition.strftime("%Y%m%dT%H%M%S.%f")}}
        }
    )
    
def check_latest_date(min_ingestion_dttm, partition):
    res = True
    try:
        res = bool(dt.datetime.strptime(min_ingestion_dttm, "%Y%m%dT%H%M%S.%f"))
    except ValueError:
        res = False
    
    if res:
        if dt.datetime.strptime(min_ingestion_dttm, "%Y%m%dT%H%M%S.%f") >= partition:
            return False
    return True

def lambda_handler(event, context):
    table_name = event["table_name"]["S"]
    
    URL, PARTITIONS_URI = getting_global_uri()
    min_ingestion_dttm, job_table_uri = getting_table_cofiguration(table_name)
    
    partitions = requests.get(URL + PARTITIONS_URI.format(table_name=table_name))
    
    latest_partition = max([dt.datetime.strptime(element, "%Y%m%dT%H%M%S.%f") for element in partitions.json()])
    
    if check_latest_date(min_ingestion_dttm, latest_partition):
        save_partitons(partitions, min_ingestion_dttm, job_table_uri, URL, table_name)
        
        update_min_ingestion_dttm(table_name, latest_partition)
        return table_name +  ": " + latest_partition.strftime("%Y%m%dT%H%M%S.%f")
    else:
        return table_name + ": No new partitions!"