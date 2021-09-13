#!/bin/bash

echo "Importing Organization"
cd import-org
terraform init

# RUN THIS FOLLOWING COMMAND ONLY FOR THE FIRST TIME
echo "Fill in the Org ID for your AWS Organization"
terraform import aws_organizations_organization.my_org <YOUR-ORG-ID>

terraform plan

echo "Update the Service access principals under inport-org/main.tf before applying"

terraform apply -auto-approve
echo "Done !"
cd ..


echo "Fill in the variables.tf file under the create-gd-bucket-and-key folder"
echo "Creating GuardDuty Findings bucket and key"
cd create-gd-bucket-and-key
terraform init
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..


echo "Fill in the variables.tf file under the enable-gd folder"
echo "Turning on GuardDuty"
cd enable-gd
terraform init
terraform plan
terraform apply -auto-approve
echo "Done !"
cd ..

