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

import os
import json
import sys
import getopt
import boto3
import re
import csv
import datetime

print('Number of arguments:', len(sys.argv), 'arguments.')
print('Argument List:', str(sys.argv))

if (len(sys.argv) != 3):
  print('The script needs the security account id and name of a role to assume as arguments')
  exit()

def assume_role(aws_account_number, role_name):

    # Beginning the assume role process for account
    sts_client = boto3.client('sts')
    partition = sts_client.get_caller_identity()['Arn'].split(':')[1]

    response = sts_client.assume_role(
        RoleArn=f'arn:{partition}:iam::{aws_account_number}:role/{role_name}',
        RoleSessionName='EnableGuardDuty'
    )

    # Storing STS credentials
    sts_session = boto3.Session(
        aws_access_key_id=response['Credentials']['AccessKeyId'],
        aws_secret_access_key=response['Credentials']['SecretAccessKey'],
        aws_session_token=response['Credentials']['SessionToken']
    )
    print(f'Assumed session for {aws_account_number}.')

    return sts_session


disclaimer = """
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

"""
ssm = boto3.client('ssm')

# ============================================================================
# To select all supported regions for which to generate the GuardDuty-enabler code, a 3-step process is done below:
# a) The list of regions where GuardDuty service is available is retrieved
# b) The list of enabled-cum-opted-in regions for the delegated admin account is retrieved
# c) The intersection of (a) and (b) is the resultant 'allowed' regions for which code is generated
# ============================================================================

# (a) The list of regions where GuardDuty service is available is retrieved
#
params = []
res = ssm.get_parameters_by_path(Path='/aws/service/global-infrastructure/services/guardduty/regions')
params = params + res['Parameters']
while ('NextToken' in res):
  res = ssm.get_parameters_by_path(Path='/aws/service/global-infrastructure/services/guardduty/regions', NextToken=res['NextToken'])
  params = params + res['Parameters']
gd_allowed_regions = []
for param in params:
  gd_allowed_regions.append(param['Value'])

# (b) The list of enabled-cum-opted-in regions for the delegated admin account is retrieved
#
delg_admin_session = assume_role(sys.argv[1].strip('"'), sys.argv[2].strip('"'))
ec2 = delg_admin_session.client('ec2')
res = ec2.describe_regions(Filters=[{'Name':'opt-in-status', 'Values':['opt-in-not-required','opted-in']}])
opted_regions = []
for region in res['Regions']:
  opted_regions.append(region['RegionName'])

# (c) Intersect the two lists above for the final allowed regions
# 
allowed_regions = list(set(gd_allowed_regions) & set(opted_regions))

provider_default = """
provider "aws" {
  region = var.default_region
}
"""
provider = """
provider "aws" {
  alias  = "{{region}}a"
  region = "{{region}}"
}

provider "aws" {
  alias  = "{{region}}b"
  region = "{{region}}"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}
"""

file1 = open("enable-gd/providers.tf", "w")
file1.write(disclaimer)
file1.write(provider_default)
for region in allowed_regions:
  file1.write(provider.replace("{{region}}", region))
file1.close()

enable_gd_locals = """
# --------------------------------------------------------------------------------------------------
# GuardDuty enabler root module
# Needs to be set up in each region.
# --------------------------------------------------------------------------------------------------
locals {
  guardduty_admin_account_id             = var.delegated_admin_acc_id
  guardduty_finding_publishing_frequency = var.finding_publishing_frequency
  guardduty_findings_bucket_arn          = data.terraform_remote_state.guardduty_findings_store.outputs.guardduty_findings_bucket_arn
  guardduty_findings_kms_key_arn         = data.terraform_remote_state.guardduty_findings_store.outputs.guardduty_findings_kms_key_arn
  allowed_regions                        = split(",", var.target_regions)
}
"""

enable_gd_entity = """
# AWS region "{{region}}" specific module
#
module "guardduty_baseline_{{region}}" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.{{region}}a
    aws.dst = aws.{{region}}b
  }

  enabled                         = contains(local.allowed_regions, "{{region}}")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}
"""

file1 = open("enable-gd/tfm-gd-enabler.tf", "w")
file1.write(disclaimer)
file1.write(enable_gd_locals)
for region in allowed_regions:
  file1.write(enable_gd_entity.replace("{{region}}", region))
file1.close()

enable_gd_output_header = """
output "guardduty_detector" {
  description = "The GuardDuty detector in each region."

  value = {
"""

enable_gd_output_item = '"{{region}}" = module.guardduty_baseline_{{region}}.guardduty_detector'
enable_gd_output_footer = """
  }
}
"""

file1 = open("enable-gd/outputs.tf", "w")
file1.write(disclaimer)
file1.write(enable_gd_output_header)

for region in allowed_regions:
  file1.write('    ' + enable_gd_output_item.replace("{{region}}", region.strip('"')) + '\n')

file1.write(enable_gd_output_footer)

file1.close()

