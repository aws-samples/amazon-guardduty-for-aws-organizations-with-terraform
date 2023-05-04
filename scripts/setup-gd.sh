#!/bin/bash

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
## Internal Script used by scripts/full-setup.sh to import org and enable GuardDuty
#######################################################################################

# Colour highlighting
MAG='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Replace Organization stub with org ID from configuration file
#
org_id=`cat configuration.json | jq -r ".organization_id"`


cd import-org

# Note - IMPORT OF ORG WILL PASS THE FIRST TIME; TERRAFORM WILL REPORT
# ERROR THE SECOND TIME; THE ERROR CAN BE IGNORED
terraform init -upgrade
echo -e "${MAG}Importing Organization${NC}"
terraform import aws_organizations_organization.my_org $org_id
echo -e "${BLUE}Done !${NC}"
echo ""
cd ..

echo -e "${MAG}Creating GuardDuty Findings bucket and key${NC}"
cd create-gd-bucket-and-key
terraform init -upgrade
terraform apply -auto-approve
echo -e "${BLUE}Done !${NC}"
echo ""
cd ..

# Generate the terraform code for all allowed regions
#
delegated_admin_acc_id=`cat configuration.json | jq -r ".delegated_admin_acc_id"`
cd create-delegatedadmin-acct-role
role_to_assume=`terraform output -json security_acct_role_to_assume`
cd ..
python3 enable-gd/build-template.py $delegated_admin_acc_id $role_to_assume

echo -e "${MAG}Turning on GuardDuty${NC}"
cd enable-gd
terraform init -upgrade
terraform apply -auto-approve
echo -e "${BLUE}Done !${NC}"
echo ""
cd ..

