#!/bin/bash

# Initialize terraform variables
export TF_VAR_delegated_admin_acc_id=`cat configuration.json | jq -r ".delegated_admin_acc_id"`
export TF_VAR_logging_acc_id=`cat configuration.json | jq -r ".logging_acc_id"`
export TF_VAR_target_regions=`cat configuration.json | jq -r ".target_regions"`
export TF_VAR_organization_id=`cat configuration.json | jq -r ".organization_id"`
export TF_VAR_default_region=`cat configuration.json | jq -r ".default_region"`
export TF_VAR_role_to_assume_for_role_creation=`cat configuration.json | jq -r ".role_to_assume_for_role_creation"`

export TF_VAR_finding_publishing_frequency=`cat configuration.json | jq -r ".finding_publishing_frequency"`
export TF_VAR_guardduty_findings_bucket_region=`cat configuration.json | jq -r ".guardduty_findings_bucket_region"`
export TF_VAR_logging_acc_s3_bucket_name=`cat configuration.json | jq -r ".logging_acc_s3_bucket_name"`
export TF_VAR_logging_acc_kms_key_alias=`cat configuration.json | jq -r ".logging_acc_kms_key_alias"`
export TF_VAR_s3_access_log_bucket_name=`cat configuration.json | jq -r ".s3_access_log_bucket_name"`

# Initialize code files based on input configuration
#
bash scripts/generate-backend.sh

# Create necessary roles in security and logging accounts
#
bash scripts/create-roles.sh

# Enable GD for the AWS Organizations
#
bash scripts/setup-gd.sh
