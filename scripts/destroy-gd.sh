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