import json

import boto3

def lambda_handler(event, context):
    # TODO implement
    
    client = boto3.client('sns')
    snsArn = 'arn:aws:sns:eu-central-1:456582705970:avujic-academy-sns-lambda'
    message = event["message"]
    
    try:
        response = client.publish(
            TopicArn = snsArn,
            Message = message,
            Subject='Hello'
        )
    except:
        response = client.publish(
            TopicArn = snsArn,
            Message = 'Error',
            Subject='Hello'
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
