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
logging_acc_id=`cat configuration.json | jq '.logging_acc_id'`
delegated_admin_acc_id=`cat configuration.json | jq '.delegated_admin_acc_id'`
default_region=`cat configuration.json | jq '.default_region'`
role_to_assume_for_role_creation=`cat configuration.json | jq '.role_to_assume_for_role_creation'`
logging_acc_s3_bucket_name=`cat configuration.json | jq '.logging_acc_s3_bucket_name'`
security_acc_kms_key_alias=`cat configuration.json | jq '.security_acc_kms_key_alias'`
guardduty_findings_bucket_region=`cat configuration.json | jq '.guardduty_findings_bucket_region'`
s3_access_log_bucket_name=`cat configuration.json | jq '.s3_access_log_bucket_name'`

cp -rf create-delegatedadmin-acct-role/tfvars.template create-delegatedadmin-acct-role/terraform.tfvars
sed -i="" "s/<delegated_admin_acc_id>/${delegated_admin_acc_id}/" create-delegatedadmin-acct-role/terraform.tfvars
sed -i="" "s/<default_region>/${default_region}/" create-delegatedadmin-acct-role/terraform.tfvars
sed -i="" "s/<role_to_assume_for_role_creation>/${role_to_assume_for_role_creation}/" create-delegatedadmin-acct-role/terraform.tfvars

cp -rf create-logging-acct-role/tfvars.template create-logging-acct-role/terraform.tfvars
sed -i="" "s/<logging_acc_id>/${logging_acc_id}/" create-logging-acct-role/terraform.tfvars
sed -i="" "s/<default_region>/${default_region}/" create-logging-acct-role/terraform.tfvars
sed -i="" "s/<role_to_assume_for_role_creation>/${role_to_assume_for_role_creation}/" create-logging-acct-role/terraform.tfvars

cp -rf create-gd-bucket-and-key/tfvars.template create-gd-bucket-and-key/terraform.tfvars
sed -i="" "s/<logging_acc_id>/${logging_acc_id}/" create-gd-bucket-and-key/terraform.tfvars
sed -i="" "s/<guardduty_findings_bucket_region>/${guardduty_findings_bucket_region}/" create-gd-bucket-and-key/terraform.tfvars
sed -i="" "s/<security_acc_kms_key_alias>/${security_acc_kms_key_alias}/" create-gd-bucket-and-key/terraform.tfvars
sed -i="" "s/<logging_acc_s3_bucket_name>/${logging_acc_s3_bucket_name}/" create-gd-bucket-and-key/terraform.tfvars
sed -i="" "s/<s3_access_log_bucket_name>/${s3_access_log_bucket_name}/" create-gd-bucket-and-key/terraform.tfvars

rm create-delegatedadmin-acct-role/terraform.tfvars=
rm create-logging-acct-role/terraform.tfvars=
rm create-gd-bucket-and-key/terraform.tfvars=
