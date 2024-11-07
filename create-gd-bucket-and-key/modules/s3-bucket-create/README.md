# s3-bucket-create

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.key"></a> [aws.key](#provider\_aws.key) | n/a |
| <a name="provider_aws.src"></a> [aws.src](#provider\_aws.src) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.gd_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.gd_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.gd_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.gd_bucket_block_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_iam_policy_document.bucket_pol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_pol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_name"></a> [assume\_role\_name](#input\_assume\_role\_name) | The role to assume in the logging account. | `any` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create the bucket and key | `any` | n/a | yes |
| <a name="input_delegated_admin_acc_id"></a> [delegated\_admin\_acc\_id](#input\_delegated\_admin\_acc\_id) | The account id of the delegated administrator account. | `any` | n/a | yes |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Alias for the KMS key to be created that will be used for encrypting logs at rest in the S3 bucket | `any` | n/a | yes |
| <a name="input_logging_acc_id"></a> [logging\_acc\_id](#input\_logging\_acc\_id) | The account id of the logging account. | `any` | n/a | yes |
| <a name="input_s3_access_log_bucket_name"></a> [s3\_access\_log\_bucket\_name](#input\_s3\_access\_log\_bucket\_name) | Bucket to store access logs for GD bucket | `string` | n/a | yes |
| <a name="input_s3_bucket_enable_object_deletion"></a> [s3\_bucket\_enable\_object\_deletion](#input\_s3\_bucket\_enable\_object\_deletion) | n/a | `bool` | `false` | no |
| <a name="input_s3_bucket_enable_object_transition_to_glacier"></a> [s3\_bucket\_enable\_object\_transition\_to\_glacier](#input\_s3\_bucket\_enable\_object\_transition\_to\_glacier) | S3 Lifecycle variables | `bool` | `true` | no |
| <a name="input_s3_bucket_object_deletion_after_days"></a> [s3\_bucket\_object\_deletion\_after\_days](#input\_s3\_bucket\_object\_deletion\_after\_days) | n/a | `number` | `1095` | no |
| <a name="input_s3_bucket_object_transition_to_glacier_after_days"></a> [s3\_bucket\_object\_transition\_to\_glacier\_after\_days](#input\_s3\_bucket\_object\_transition\_to\_glacier\_after\_days) | n/a | `number` | `365` | no |
| <a name="input_s3_logging_bucket_name"></a> [s3\_logging\_bucket\_name](#input\_s3\_logging\_bucket\_name) | Name of logging bucket to be created | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_findings_bucket_arn"></a> [guardduty\_findings\_bucket\_arn](#output\_guardduty\_findings\_bucket\_arn) | The GuardDuty findings bucket ARN. |
| <a name="output_guardduty_findings_bucket_name"></a> [guardduty\_findings\_bucket\_name](#output\_guardduty\_findings\_bucket\_name) | The GuardDuty findings bucket name. |
| <a name="output_guardduty_kms_key_arn"></a> [guardduty\_kms\_key\_arn](#output\_guardduty\_kms\_key\_arn) | The GuardDuty KMS key ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
