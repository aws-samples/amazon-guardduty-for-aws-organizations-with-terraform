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

#######################################################################
## Internal Script used by scripts/full-setup.sh to create IAM roles
#######################################################################

# Colour highlighting
MAG='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "Create the Pipeline role in the management account:"
echo "1. Use the management-account-policy.json to create a role in the Management account"
echo "2. Assume this role and use the temp credentials of this role to continue"
echo "3. Fill in the variables.tf files in the create-delegatedadmin-acct-role and create-logging-acct-role folders"

echo "Press any key to continue..."
read -n 1

echo -e "${MAG}Creating the Delegated admin account role${NC}"
cd create-delegatedadmin-acct-role
terraform init -upgrade
terraform apply -auto-approve
echo -e "${BLUE}Done !${NC}"
echo ""
cd ..


echo -e "${MAG}Creating the Logging account role${NC}"
cd create-logging-acct-role
terraform init -upgrade
terraform apply -auto-approve
echo -e "${BLUE}Done !${NC}"
echo ""
cd ..