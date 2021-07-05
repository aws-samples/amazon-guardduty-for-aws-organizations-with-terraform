#!/bin/bash

echo "Create the Pipeline role"

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