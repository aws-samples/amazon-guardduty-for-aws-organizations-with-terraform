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

#######################################################################
## Internal Script used by scripts/full-setup.sh to create IAM roles
#######################################################################

# Color highlighting
MAG='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${MAG}Ensure that the following steps are done, before proceeding"
echo -e "  1. Fill in the configuration.json file with all values"
echo -e "  2. Create IAM roles in the security and logging accounts with permissions to create IAM role"
echo -e "  3. Create an IAM role in the management account with minimum required permissions"
echo -e "  4. Assume this role and use the temp credentials of this role to continue${NC}\n"
read -n 1 -p "Press any key to continue..."

echo -e "\n${MAG}########################################################"
echo -e "Create delegated admin account role"
echo -e "########################################################${NC}"

cd create-delegatedadmin-acct-role
terraform init -upgrade
terraform apply -auto-approve
echo -e "\n${BLUE}Done!\n##########${NC}"
cd ..

# Replace the guardduty findings bucket name stub with value from configuration file in create-logging-acct-role/create-role.tf
logging_acc_s3_bucket_name=`cat configuration.json | jq '.logging_acc_s3_bucket_name'`
cp create-logging-acct-role/create-role.template create-logging-acct-role/create-role.tf
sed -i="" "s/<logging_acc_s3_bucket_name>/${logging_acc_s3_bucket_name}/" create-logging-acct-role/create-role.tf
rm create-logging-acct-role/create-role.tf=

echo -e "\n${MAG}########################################################"
echo -e "Create logging account role"
echo -e "########################################################${NC}"
cd create-logging-acct-role
terraform init -upgrade
terraform apply -auto-approve
echo -e "\n${BLUE}Done!\n##########${NC}"
cd ..
