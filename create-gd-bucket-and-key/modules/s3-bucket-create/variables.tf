
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


variable "logging_acc_id" {
  description = "The account id of the logging account."
}

variable "delegated_admin_acc_id" {
  description = "The account id of the delegated administrator account."
}

variable "assume_role_name" {
  description = "The role to assume in the logging account."
}

variable "tags" {
  description = "Specifies object tags key and value. This applies to all resources created by this module."
  default = {
  }
}

variable "default_region" {
  description = "Default region to create the bucket and key"
}

variable "kms_key_alias" {
  description = "Alias for the KMS key to be created that will be used for encrypting logs at rest in the S3 bucket"
}

variable "s3_logging_bucket_name" {
  description = "Name of logging bucket to be created"
}

# S3 Lifecycle variables
variable "s3_bucket_enable_object_transition_to_glacier" {
  default = true
}

variable "s3_bucket_object_transition_to_glacier_after_days" {
  default = 365
}

variable "s3_bucket_enable_object_deletion" {
  default = false
}

variable "s3_bucket_object_deletion_after_days" {
  default = 1095
}

variable "s3_access_log_bucket_name" {
  type        = string
  description = "Bucket to store access logs for GD bucket"
}
