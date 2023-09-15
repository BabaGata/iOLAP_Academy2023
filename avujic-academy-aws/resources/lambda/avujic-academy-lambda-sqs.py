import boto3
import json

def lambda_handler(event, context):
    sns = boto3.client('sns')
    snsArn = 'arn:aws:sns:eu-central-1:456582705970:avujic-academy-sns-lambda'
    # message = json.dumps(event, indent=4)
    records = event["Records"][0]
    # messege = json.loads(message)
    records = json.loads(records["body"])
    records = records["Records"][0]
    
    message = "s3 bucket: {0}\nEvent: {1}\nObject: {2}\nEvent time: {3}\n\n{4}".format(
        records["s3"]["bucket"]["name"],
        records["s3"]["configurationId"],
        records["s3"]["object"]["key"],
        records["eventTime"],
        json.dumps(records, indent=4)
    )
    
    subject = "{0}: {1}, {2}, {3}".format(
        records["s3"]["configurationId"],
        records["s3"]["bucket"]["name"],
        records["s3"]["object"]["key"],
        records["eventTime"]
    )
    
    try:
        response = sns.publish(
            TopicArn = snsArn,
            Message = message,
            Subject = subject
        )
    except  Exception as e:
        response = sns.publish(
            TopicArn = snsArn,
            Message = str(e),
            Subject = "Exception from sqs for s3 events"
        )
    
    return message