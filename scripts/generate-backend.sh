#!/bin/bash

# Replace Terraform backend S3 bucket and DynamoDB table stubs based on configuration
#
tfm_state_s3=`cat configuration.json | jq '.tfm_state_backend_s3_bucket'`
tfm_state_dynamodb=`cat configuration.json | jq '.tfm_state_backend_dynamodb_table'`
tfm_state_region=`cat configuration.json | jq '.tfm_state_region'`

cp -rf create-delegatedadmin-acct-role/backend.template create-delegatedadmin-acct-role/backend.tf
sed -i "" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" create-delegatedadmin-acct-role/backend.tf
sed -i "" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" create-delegatedadmin-acct-role/backend.tf
sed -i "" "s/<tfm_state_region>/${tfm_state_region}/" create-delegatedadmin-acct-role/backend.tf

cp -rf create-logging-acct-role/backend.template create-logging-acct-role/backend.tf
sed -i "" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" create-logging-acct-role/backend.tf
sed -i "" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" create-logging-acct-role/backend.tf
sed -i "" "s/<tfm_state_region>/${tfm_state_region}/" create-logging-acct-role/backend.tf

cp -rf create-gd-bucket-and-key/backend.template create-gd-bucket-and-key/backend.tf
sed -i "" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" create-gd-bucket-and-key/backend.tf
sed -i "" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" create-gd-bucket-and-key/backend.tf
sed -i "" "s/<tfm_state_region>/${tfm_state_region}/" create-gd-bucket-and-key/backend.tf

cp -rf enable-gd/backend.template enable-gd/backend.tf
sed -i "" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" enable-gd/backend.tf
sed -i "" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" enable-gd/backend.tf
sed -i "" "s/<tfm_state_region>/${tfm_state_region}/" enable-gd/backend.tf

cp -rf import-org/backend.template import-org/backend.tf
sed -i "" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" import-org/backend.tf
sed -i "" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" import-org/backend.tf
sed -i "" "s/<tfm_state_region>/${tfm_state_region}/" import-org/backend.tf