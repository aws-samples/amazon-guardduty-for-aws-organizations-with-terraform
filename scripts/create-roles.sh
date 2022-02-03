#!/bin/bash

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