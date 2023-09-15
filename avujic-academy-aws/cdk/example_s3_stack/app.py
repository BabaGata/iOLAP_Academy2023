#!/usr/bin/env python3
import aws_cdk as cdk

from example_s3_stack.example_s3_stack_stack import ExampleS3StackStack


app = cdk.App()
ExampleS3StackStack(
    app,
    "avujic-AcademyS3Stack",
    env=cdk.Environment(account="456582705970", region="eu-central-1"),
)

app.synth()