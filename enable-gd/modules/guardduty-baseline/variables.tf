variable "enabled" {
  description = "The boolean flag whether this module is enabled or not. No resources are created when set to false."
  default     = false
}

variable "gd_delegated_admin_acc_id" {
  description = "The account id of the delegated admin."
}

variable "gd_finding_publishing_frequency" {
  description = "Specifies the frequency of notifications sent for subsequent finding occurrences."
  default     = "SIX_HOURS"
}

variable "tags" {
  description = "Specifies object tags key and value. This applies to all resources created by this module."
  default = {
  }
}

variable "gd_my_org" {
  description = "The AWS Organization with all the accounts"
}

variable "gd_publishing_dest_bucket_arn" {
  description = "The bucket ARN to publish GD findings"
}

variable "gd_kms_key_arn" {
  description = "The KMS key to encrypt GD findings in the S3 bucket"
}