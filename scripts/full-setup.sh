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

#######################################################################################
## Main script to setup the entire workflow
#######################################################################################

# exit when any command fails
set -e

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
export TF_VAR_security_acc_kms_key_alias=`cat configuration.json | jq -r ".security_acc_kms_key_alias"`
export TF_VAR_s3_access_log_bucket_name=`cat configuration.json | jq -r ".s3_access_log_bucket_name"`

# Set default region of operation
#
export AWS_REGION=$TF_VAR_default_region

# Initialize code files based on input configuration
#
bash scripts/generate-backend.sh

# Create the .tfvar files for setting backend
#
bash scripts/generate-tfvars.sh

# Create necessary roles in security and logging accounts
#
bash scripts/create-roles.sh

# Enable GD for the AWS Organizations
#
bash scripts/setup-gd.sh
