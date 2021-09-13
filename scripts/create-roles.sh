#!/bin/bash

echo "Create the Pipeline role in the management account:"
echo "1. Use the management-account-policy.json to create a role in the Management account"
echo "2. Assume this role and use the temp credentials of this role to continue"
echo "3. Fill in the variables.tf files in the create-delegatedadmin-acct-role and create-logging-acct-role folders"

echo "Create the Delegated admin account role"
cd create-delegatedadmin-acct-role
terraform init
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..


echo "Create the Logging account role"
cd create-logging-acct-role
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..