export OWNER_NAME="vujic.agata@gmail.com"
export S3_STACK_NAME="avujic-academy-stack-s3"
export S3_BUCKET_SCRIPTS="avujic-academy-scripts"
export S3_BUCKET_DATA="avujic-academy-data"

export DYNAMO_STACK_NAME="avujic-academy-stack-dynamodb"
export DYNAMO_GLOBAL="avujic-academy-global"
export DYNAMO_JOBS="avujic-academy-jobs"

export LAMBDA_STACK_NAME="avujic-academy-stack-lambda"
export LAMBDA_FUNCTION_NAME="avujic-academy-lambda-cloudformation"
export LAMBDA_LANDING_ROLE_NAME="avujic-academy-lambda-role"
export LAMBDA_LANDING_NAME="avujic-academy-lambda-landing"
export LambdaLandingUploadUNIXT=$(date +%s)

export SCHEDULE_STACK_NAME="avujic-academy-schedule"

export STATE_MACHINE_STACK_NAME="avujic-academy-statemachine"
export STATE_MACHINE_TRIGGER_ROLE_NAME="avujic-academy-statemachine-trigger"

export GLUE_STACK_NAME="avujic-academy-glue"
export GLUE_JOB_ROLE_NAME="avujic-academy-glue-role"
export GLUE_DATABASE_LANDING_NAME="avujic-academy-landing"
export GLUE_DATABASE_DATALAKE_NAME="avujic-academy-datalake"
export GLUE_CRAWLER_LANDING_TRIGGER_NAME="avujic-crawler-landing-trigger"
export GLUE_CRAWLER_LANDING_NAME="avujic-crawler-landing"
export GLUE_CRAWLER_DATALAKE_TRIGGER_NAME="avujic-crawler-datalake-trigger"
export GLUE_CRAWLER_DATALAKE_NAME="avujic-crawler-datalake"
export GLUE_JOB_TRIGGER_NAME="avujic-job-trigger"

aws cloudformation deploy \
  --template-file "cicd/s3.yml" \
  --stack-name $S3_STACK_NAME \
  --parameter-overrides \
    S3BucketData=$S3_BUCKET_DATA \
    S3BucketScripts=$S3_BUCKET_SCRIPTS \
  --tags Owner=$OWNER_NAME

aws cloudformation deploy \
  --template-file "cicd/dynamodb.yml" \
  --stack-name $DYNAMO_STACK_NAME \
  --parameter-overrides \
    DynamoDBGlobal=$DYNAMO_GLOBAL \
    DynamoDBJobs=$DYNAMO_JOBS \
  --tags Owner=$OWNER_NAME

aws cloudformation deploy \
  --template-file "cicd/lambda.yml" \
  --stack-name $LAMBDA_STACK_NAME \
  --parameter-overrides \
    S3BucketScripts=$S3_BUCKET_SCRIPTS \
    LambdaLandingUploadUNIXT=$LambdaLandingUploadUNIXT \
    LambdaFunctionName=$LAMBDA_FUNCTION_NAME \
  --tags Owner=$OWNER_NAME

aws cloudformation deploy \
  --template-file "cicd/schedule.yml" \
  --stack-name $SCHEDULE_STACK_NAME \
  --parameter-overrides \
    LambdaFunction=$LAMBDA_FUNCTION_NAME \
  --tags Owner=$OWNER_NAME

aws cloudformation deploy \
  --template-file "cicd/statemachine.yml" \
  --stack-name $STATE_MACHINE_STACK_NAME \
  --parameter-overrides \
    S3BucketData=$S3_BUCKET_DATA \
    S3BucketScripts=$S3_BUCKET_SCRIPTS \
    DynamoDBTableGlobalName=$DYNAMO_GLOBAL \
    DynamoDBTableJobsName=$DYNAMO_JOBS \
    StateMachineName=$STATE_MACHINE_STACK_NAME \
    StateMachineRoleName=$STATE_MACHINE_STACK_NAME \
    StateMachineTriggerRoleName=$STATE_MACHINE_TRIGGER_ROLE_NAME \
    LambdaLandingName=$LAMBDA_LANDING_NAME \
    LambdaLandingRoleName=$LAMBDA_LANDING_ROLE_NAME \
    LambdaLandingUploadUNIXT=$LambdaLandingUploadUNIXT \
  --tags Owner=$OWNER_NAME \
  --capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy \
  --template-file "cicd/glue.yml" \
  --stack-name $GLUE_STACK_NAME \
  --parameter-overrides \
    S3BucketData=$S3_BUCKET_DATA \
    S3BucketScripts=$S3_BUCKET_SCRIPTS \
    GlueJobName=$GLUE_STACK_NAME \
    GlueJobRoleName=$GLUE_JOB_ROLE_NAME \
    GlueDatabaseLandingName=$GLUE_DATABASE_LANDING_NAME \
    GlueDatabaseDatalakeName=$GLUE_DATABASE_DATALAKE_NAME \
    GlueCrawlerLandingTriggerName=$GLUE_CRAWLER_LANDING_TRIGGER_NAME \
    GlueCrawlerLandingName=$GLUE_CRAWLER_LANDING_NAME \
    GlueCrawlerDatalakeTriggerName=$GLUE_CRAWLER_DATALAKE_TRIGGER_NAME \
    GlueCrawlerDatalakeName=$GLUE_CRAWLER_DATALAKE_NAME \
    GlueJobTriggerName=$GLUE_JOB_TRIGGER_NAME \
  --tags Owner=$OWNER_NAME \
  --capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy \
  --template-file "cicd/codepipeline.yml" \
  --stack-name "avujic-academy-codepipeline-cicd" \
  --tags Owner=$OWNER_NAME \
  --capabilities CAPABILITY_NAMED_IAM

zip -r9j \
  resources/s3/avujic-academy-scripts/lambda/$LAMBDA_FUNCTION_NAME.zip \
  resources/s3/avujic-academy-scripts/lambda/$LAMBDA_FUNCTION_NAME.py

zip -r9j \
  resources/s3/avujic-academy-scripts/lambda/$LAMBDA_LANDING_NAME.zip \
  resources/s3/avujic-academy-scripts/lambda/$LAMBDA_LANDING_NAME.py

aws s3 sync resources/s3/avujic-academy-scripts/lambda/ s3://${S3_BUCKET_SCRIPTS}/lambda/${LambdaLandingUploadUNIXT}/
aws s3 sync resources/s3/avujic-academy-scripts/statemachine/ s3://${S3_BUCKET_SCRIPTS}/statemachine/
aws s3 sync resources/s3/avujic-academy-scripts/dynamodb/items/ s3://${S3_BUCKET_SCRIPTS}/dynamodb/items/
aws s3 sync resources/s3/avujic-academy-scripts/glue/ s3://${S3_BUCKET_SCRIPTS}/glue/


- echo "=============== Lambda Scheadule stack Deployment ================"
      - >
        aws cloudformation deploy \
          --template-file "cicd/schedule.yml" \
          --stack-name $SCHEDULE_STACK_NAME \
          --parameters-overrides \
            LambdaFunction=$LAMBDA_FUNCTION_NAME \
          --tags Owner=$OWNER_NAME
      - echo "=============== Lambda Scheadule stack Complete ================"