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

tfm_state_backend_s3_bucket=`cat configuration.json | jq -r '.tfm_state_backend_s3_bucket'`
tfm_state_backend_dynamodb_table=`cat configuration.json | jq -r '.tfm_state_backend_dynamodb_table'`
default_region=`cat configuration.json | jq -r '.default_region'`
management_acc_id=`cat configuration.json | jq -r '.management_acc_id'`
delegated_admin_acc_id=`cat configuration.json | jq -r '.delegated_admin_acc_id'`
logging_acc_id=`cat configuration.json | jq -r '.logging_acc_id'`
organization_id=`cat configuration.json | jq -r '.organization_id'`
role_to_assume_for_role_creation=`cat configuration.json | jq -r '.role_to_assume_for_role_creation'`

cp -rf cfn-templates/management-account-role.cfntemplate cfn-templates/management-account-role.yaml
sed -i="" "s/<tfm_state_backend_s3_bucket>/${tfm_state_backend_s3_bucket}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<tfm_state_backend_dynamodb_table>/${tfm_state_backend_dynamodb_table}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<default_region>/${default_region}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<management_acc_id>/${management_acc_id}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<delegated_admin_acc_id>/${delegated_admin_acc_id}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<logging_acc_id>/${logging_acc_id}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<organization_id>/${organization_id}/" cfn-templates/management-account-role.yaml
sed -i="" "s/<role_to_assume_for_role_creation>/${role_to_assume_for_role_creation}/" cfn-templates/management-account-role.yaml

cp -rf cfn-templates/role-to-assume-for-role-creation.cfntemplate cfn-templates/role-to-assume-for-role-creation.yaml
sed -i="" "s/<management_acc_id>/${management_acc_id}/" cfn-templates/role-to-assume-for-role-creation.yaml
sed -i="" "s/<organization_id>/${organization_id}/" cfn-templates/role-to-assume-for-role-creation.yaml
sed -i="" "s/<role_to_assume_for_role_creation>/${role_to_assume_for_role_creation}/" cfn-templates/role-to-assume-for-role-creation.yaml

rm cfn-templates/management-account-role.yaml=
rm cfn-templates/role-to-assume-for-role-creation.yaml=
