#!/bin/bash

# Colour highlighting
MAG='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Replace Organization stub with org ID from configuration file
#
org_id=`cat configuration.json | jq -r ".organization_id"`

echo -e "${MAG}Importing Organization${NC}"
cd import-org
terraform init -upgrade

# Note - IMPORT OF ORG WILL PASS THE FIRST TIME; TFM WILL REPORT
# ERROR THE SECOND TIME; THE ERROR CAN BE IGNORED
terraform import aws_organizations_organization.my_org $org_id
terraform apply -auto-approve
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
role_to_assume=`terraform output -json security_acct_role_to_assume | jq -r`
cd ..
python3 enable-gd/build-template.py $delegated_admin_acc_id $role_to_assume

echo -e "${MAG}Turning on GuardDuty${NC}"
cd enable-gd
terraform init -upgrade
terraform apply -auto-approve
echo -e "${BLUE}Done !${NC}"
echo ""
cd ..

