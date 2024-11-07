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

# Create (one-time) the S3 bucket and KMS CMK for GuardDuty findings
module "gd_findings_bucket_and_key" {
  source = "./modules/s3-bucket-create"

  providers = {
    aws.src = aws.default
    aws.key = aws.delegatedadmin
  }

  logging_acc_id                                    = var.logging_acc_id
  delegated_admin_acc_id                            = var.delegated_admin_acc_id
  assume_role_name                                  = var.assume_role_name
  kms_key_alias                                     = var.security_acc_kms_key_alias
  s3_logging_bucket_name                            = var.logging_acc_s3_bucket_name
  s3_access_log_bucket_name                         = var.s3_access_log_bucket_name
  default_region                                    = var.guardduty_findings_bucket_region
  s3_bucket_object_transition_to_glacier_after_days = var.lifecycle_policy_days
  tags                                              = var.tags
}
