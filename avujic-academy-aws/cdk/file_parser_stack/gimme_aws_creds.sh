#!/usr/bin/bash
username=$1
token_code=$2
if [ -z $username ] || [ -z $token_code ];
then
    echo "Usage: gimme_aws_creds.sh <username> <token-code>"
    echo -e "\ne.g. ./gimme_aws_creds.sh ahrelja 123456"
    exit 1
fi

aws_token=$(aws sts get-session-token \
    --serial-number arn:aws:iam::456582705970:mfa/${username} \
    --token-code $token_code \
    --profile iam-user)

aws_access_key_id=$(jq -r '.Credentials.AccessKeyId' <<< "$aws_token")
aws_secret_access_key=$(jq -r '.Credentials.SecretAccessKey' <<< "$aws_token")
aws_session_token=$(jq -r '.Credentials.SessionToken' <<< "$aws_token")
expiration=$(jq -r '.Credentials.Expiration' <<< "$aws_token")

echo "[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key}
aws_session_token = ${aws_session_token}
region = eu-central-1
" > ~/.aws/config

echo "AWS Session established and written to ~/.aws/config"
echo "Expiration: ${expiration}"