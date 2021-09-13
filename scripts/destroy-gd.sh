#!/bin/bash

echo "Destroying GuardDuty"
cd enable-gd
terraform init
terraform destroy -auto-approve
echo "Done !"
cd ..


echo "Destroying GuardDuty Findings bucket and key"
cd create-gd-bucket-and-key
terraform init
terraform destroy -auto-approve
echo "Done !"
cd ..

echo "Destroying Logging account role"
cd create-logging-acct-role
terraform init
terraform destroy -auto-approve
echo "Done !"
cd ..

echo "Destroying Delegated admin role"
cd create-delegatedadmin-acct-role
terraform init
terraform destroy -auto-approve
echo "Done !"
cd ..