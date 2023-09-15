import boto3
import json

dynamodb = boto3.client('dynamodb', region_name='eu-central-1')

def lambda_handler(event, context):
    dynamodb.put_item(
        TableName='avujic-academy-lambda-cdk',
        Item={'id':{'S':event['id']},'value':{'S':event['value']}}
    )