from aws_cdk import Stack, Duration, aws_s3 as s3, aws_iam as iam
from aws_cdk import aws_lambda as Lambda, aws_dynamodb as DynamoDB
from aws_cdk import aws_lambda_event_sources as LambdaEventSources
from aws_cdk import aws_iam as iam
from constructs import Construct
import os

class Day7Stack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        cwd = os.getcwd()
        bucket = s3.Bucket(self, "avujic-academy-s3-cdk", bucket_name="avujic-academy-s3-cdk")
        
        dynamo = DynamoDB.Table(
            self, "avujic-academy-dynamo-cdk",
            partition_key=DynamoDB.Attribute(name="id", type=DynamoDB.AttributeType.STRING),
            table_name="avujic-academy-dynamo-cdk"
        )
        lambdaRole = iam.Role.from_role_arn(self, "avujic-academy-lambda-role", "arn:aws:iam::456582705970:role/avujic-academy-lambda-role", mutable=True)

        lambd = Lambda.Function(
            self, "avujic-academy-lambda-cdk",
            runtime=Lambda.Runtime.PYTHON_3_9,
            code=Lambda.Code.from_asset(os.path.join(cwd, "day_7_stack/lambda_function.zip")),
            timeout=Duration.minutes(5),
            handler="lambda_function.lambda_handler",
            role=lambdaRole,
            function_name="avujic-academy-lambda-cdk",
            environment={"TABLE_NAME": dynamo.table_name}
        )
        lambd.add_event_source(LambdaEventSources.S3EventSource(bucket, events=[s3.EventType.OBJECT_CREATED]))
