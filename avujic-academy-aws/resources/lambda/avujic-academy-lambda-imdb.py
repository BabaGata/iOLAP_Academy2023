import json
import boto3
import requests
import pandas as pd
import datetime as dt

dynamo = boto3.client('dynamodb', region_name="eu-central-1")
sns = boto3.client('sns')
s3_client = boto3.client('s3')
s3_resource = boto3.resource('s3')

def lambda_handler(event, context):
    global_config = dynamo.get_item(
        TableName='avujic-academy-global',
        Key={
            'name': {'S': 'imdb-rest-api'}
        }
    )
    
    METHOD = global_config['Item']['method']['S']
    HOST = global_config['Item']['host']['S']
    PORT = global_config['Item']['port']['S']
    PREFIX = global_config['Item']['prefix']['S']
    
    URI = global_config['Item']['uri']['S'].format(method=METHOD, host=HOST, port=PORT, prefix=PREFIX)
    PARTITIONS_URI = global_config['Item']['partitions_uri']['S']
    M_I_D = "?min_ingestion_dttm="
    BUCKET_NAME = "avujic-academy-aws"
    
    for job in global_config['Item']['jobs']['S'].split(','):
        job = job.strip('\[]"')
        print('\n' + job)
        
        jobs_config = dynamo.get_item(
            TableName='avujic-academy-jobs',
            Key={
                'table_name': {'S': job}
            }
        )
        jobs_config = jobs_config['Item']
        
        partitions = requests.get(URI + PARTITIONS_URI.format(table_name=job))
        
        latest_partition = max([dt.datetime.strptime(element, "%Y%m%dT%H%M%S.%f") for element in partitions.json()])
        min_ingestion_dttm = jobs_config['min_ingestion_dttm']['S']
        
        if min_ingestion_dttm == '':
            min_ingestion_dttm = dt.datetime(1800, 3, 17, 9, 0, 0)
        else:
            min_ingestion_dttm = dt.datetime.strptime(min_ingestion_dttm, "%Y%m%dT%H%M%S.%f")
        
        if latest_partition > min_ingestion_dttm:
            for partition in partitions.json():
                if dt.datetime.strptime(partition, "%Y%m%dT%H%M%S.%f") > min_ingestion_dttm:
                    partition_r = requests.get(URI + jobs_config['uri']['S'] + M_I_D + partition)
                    partition_r = partition_r.json()
                    
                    s3object = s3_resource.Object(BUCKET_NAME, "imdb/landing/" + job + "/" + partition + ".json")
                    s3object.put(Body = partition_r)
            
            dynamo.update_item(
                TableName = "avujic-academy-jobs",
                Key = {
                    "table_name" : {"S" : job}
                },
                AttributeUpdates = {
                    "min_ingestion_dttm" : {"Value": {"S" : latest_partition.strftime("%Y%m%dT%H%M%S.%f")}}
                }
            )
            print("Latest partition" + latest_partition.strftime("%Y%m%dT%H%M%S.%f"))
        else:
            print("No new partitons.")