#!/bin/bash

region="us-west-2"

export AWS_ACCESS_KEY_ID="john"
export AWS_SECRET_ACCESS_KEY="doe"
export AWS_DEFAULT_REGION=$region

endpoint_url="http://localstack-main:4566"
secret_id="local/secret/example"
secret_exists=$(aws secretsmanager --endpoint-url=$endpoint_url describe-secret --secret-id $secret_id 2>/dev/null)

if [ -z "$secret_exists" ]; then
    echo "Secret does not exist. Adding the secret..."

    aws --endpoint-url=$endpoint_url secretsmanager create-secret \
        --name $secret_id \
        --region $region \
        --secret-string file:///var/tmp/secrets.json
else
    echo "Secret already exists. Updating the secret..."

    aws --endpoint-url=$endpoint_url secretsmanager update-secret \
        --secret-id $secret_id \
        --region $region \
        --secret-string file:///var/tmp/secrets.json
fi
