from aws_cdk import Stack, aws_s3 as s3
from constructs import Construct


class ExampleS3StackStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)
        for i in range(5):
            bucket = s3.Bucket(self, f"avujic-academy-cdk-{i+1}", bucket_name=f"avujic-academy-cdk-{i+1}")