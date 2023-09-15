#!/usr/bin/env python3
import aws_cdk as cdk

from day_7_stack.day_7_stack import Day7Stack


app = cdk.App()
Day7Stack(
    app,
    "avujic-cdk-stack-task-2",
    env=cdk.Environment(account="456582705970", region="eu-central-1"),
)

app.synth()