#!/bin/bash

echo "Importing Organisation"
cd import-org
terraform init
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..

echo "Creating GuardDuty Findings bucket and key"
cd create-gd-bucket-and-key
terraform init
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..

echo "Turning on GuardDuty"
cd enable-gd
terraform init
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..

