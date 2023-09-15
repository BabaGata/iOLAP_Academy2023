import boto3
import logging
import sys
import json
import os

logging.basicConfig(
    format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',
    stream=sys.stdout,
    level=logging.INFO
)
logger = logging.getLogger("avujic-academy-logging-cdk")
logger.setLevel(logging.INFO)

dynamodb = boto3.client('dynamodb', region_name='eu-central-1')
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    TABLE_NAME = os.environ["TABLE_NAME"]
    logger.info(event)

    try:
        s3_Bucket_Name = event["Records"][0]["s3"]["bucket"]["name"]
        s3_File_Name = event["Records"][0]["s3"]["object"]["key"]

        object = s3_client.get_object(Bucket=s3_Bucket_Name, Key=s3_File_Name)
        body = object['Body']
        body_json = json.loads(body.read().decode('utf-8'))
        logger.info(body_json)

        dynamodb.put_item(
            TableName=TABLE_NAME,
            Item={'id':{'S':body_json['id']},'value':{'S':body_json['value']}}
        )
        logger.info("Saved {0} to {1}".format(s3_File_Name, TABLE_NAME))
    except Exception as e:
        logger.error(e)