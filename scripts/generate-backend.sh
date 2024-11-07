#!/bin/bash
set -o errexit

#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: MIT-0

#  Permission is hereby granted, free of charge, to any person obtaining a copy of this
#  software and associated documentation files (the "Software"), to deal in the Software
#  without restriction, including without limitation the rights to use, copy, modify,
#  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
#  permit persons to whom the Software is furnished to do so.

#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
#  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#######################################################################################
## Internal Script used by scripts/full-setup.sh to generate code for backend.tf files
#######################################################################################

# Replace Terraform backend S3 bucket and DynamoDB table stubs based on configuration
tfm_state_s3=`cat configuration.json | jq '.tfm_state_backend_s3_bucket'`
tfm_state_dynamodb=`cat configuration.json | jq '.tfm_state_backend_dynamodb_table'`
default_region=`cat configuration.json | jq '.default_region'`

cp -rf create-delegatedadmin-acct-role/backend.template create-delegatedadmin-acct-role/backend.tf
sed -i="" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" create-delegatedadmin-acct-role/backend.tf
sed -i="" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" create-delegatedadmin-acct-role/backend.tf
sed -i="" "s/<default_region>/${default_region}/" create-delegatedadmin-acct-role/backend.tf

cp -rf create-logging-acct-role/backend.template create-logging-acct-role/backend.tf
sed -i="" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" create-logging-acct-role/backend.tf
sed -i="" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" create-logging-acct-role/backend.tf
sed -i="" "s/<default_region>/${default_region}/" create-logging-acct-role/backend.tf

cp -rf create-gd-bucket-and-key/backend.template create-gd-bucket-and-key/backend.tf
sed -i="" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" create-gd-bucket-and-key/backend.tf
sed -i="" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" create-gd-bucket-and-key/backend.tf
sed -i="" "s/<default_region>/${default_region}/" create-gd-bucket-and-key/backend.tf

cp -rf enable-gd/backend.template enable-gd/backend.tf
sed -i="" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" enable-gd/backend.tf
sed -i="" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" enable-gd/backend.tf
sed -i="" "s/<default_region>/${default_region}/" enable-gd/backend.tf

cp -rf import-org/backend.template import-org/backend.tf
sed -i="" "s/<tfm_state_backend_s3_bucket>/${tfm_state_s3}/" import-org/backend.tf
sed -i="" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_dynamodb}/" import-org/backend.tf
sed -i="" "s/<default_region>/${default_region}/" import-org/backend.tf

rm create-delegatedadmin-acct-role/backend.tf=
rm create-logging-acct-role/backend.tf=
rm create-gd-bucket-and-key/backend.tf=
rm enable-gd/backend.tf=
rm import-org/backend.tf=
