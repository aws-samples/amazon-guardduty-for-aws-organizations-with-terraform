# create-gd-bucket-and-key

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gd_findings_bucket_and_key"></a> [gd\_findings\_bucket\_and\_key](#module\_gd\_findings\_bucket\_and\_key) | ./modules/s3-bucket-create | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_name"></a> [assume\_role\_name](#input\_assume\_role\_name) | The role to assume in the delegated admin account. | `string` | `"GuardDutyTerraformOrgRole"` | no |
| <a name="input_delegated_admin_acc_id"></a> [delegated\_admin\_acc\_id](#input\_delegated\_admin\_acc\_id) | The account id of the delegated administrator account. | `any` | n/a | yes |
| <a name="input_guardduty_findings_bucket_region"></a> [guardduty\_findings\_bucket\_region](#input\_guardduty\_findings\_bucket\_region) | Default region to create the bucket and key | `any` | n/a | yes |
| <a name="input_lifecycle_policy_days"></a> [lifecycle\_policy\_days](#input\_lifecycle\_policy\_days) | Specifies the number of days after which items are moved to Glacier. | `number` | `365` | no |
| <a name="input_logging_acc_id"></a> [logging\_acc\_id](#input\_logging\_acc\_id) | The account id of the logging account. | `any` | n/a | yes |
| <a name="input_logging_acc_s3_bucket_name"></a> [logging\_acc\_s3\_bucket\_name](#input\_logging\_acc\_s3\_bucket\_name) | Name of S3 bucket to store logs in the logging account | `any` | n/a | yes |
| <a name="input_s3_access_log_bucket_name"></a> [s3\_access\_log\_bucket\_name](#input\_s3\_access\_log\_bucket\_name) | Bucket to store access logs for GD bucket | `string` | n/a | yes |
| <a name="input_security_acc_kms_key_alias"></a> [security\_acc\_kms\_key\_alias](#input\_security\_acc\_kms\_key\_alias) | Alias of the KMS key in security account, to be used for encrypting logs at rest in s3 bucket | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_findings_bucket_arn"></a> [guardduty\_findings\_bucket\_arn](#output\_guardduty\_findings\_bucket\_arn) | The GuardDuty findings bucket in the logging account |
| <a name="output_guardduty_findings_kms_key_arn"></a> [guardduty\_findings\_kms\_key\_arn](#output\_guardduty\_findings\_kms\_key\_arn) | The GuardDuty findings bucket in the logging account |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
