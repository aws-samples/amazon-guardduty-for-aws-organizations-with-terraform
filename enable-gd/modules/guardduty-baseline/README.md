# guardduty-baseline

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.dst"></a> [aws.dst](#provider\_aws.dst) | n/a |
| <a name="provider_aws.src"></a> [aws.src](#provider\_aws.src) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_detector.MyDetector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_organization_admin_account.MyGDOrgDelegatedAdmin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_admin_account) | resource |
| [aws_guardduty_organization_configuration.MyGDOrg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration) | resource |
| [aws_guardduty_publishing_destination.pub_dest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_publishing_destination) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | The boolean flag whether this module is enabled or not. No resources are created when set to false. | `bool` | `false` | no |
| <a name="input_gd_delegated_admin_acc_id"></a> [gd\_delegated\_admin\_acc\_id](#input\_gd\_delegated\_admin\_acc\_id) | The account id of the delegated admin. | `any` | n/a | yes |
| <a name="input_gd_finding_publishing_frequency"></a> [gd\_finding\_publishing\_frequency](#input\_gd\_finding\_publishing\_frequency) | Specifies the frequency of notifications sent for subsequent finding occurrences. | `string` | `"SIX_HOURS"` | no |
| <a name="input_gd_kms_key_arn"></a> [gd\_kms\_key\_arn](#input\_gd\_kms\_key\_arn) | The KMS key to encrypt GD findings in the S3 bucket | `any` | n/a | yes |
| <a name="input_gd_my_org"></a> [gd\_my\_org](#input\_gd\_my\_org) | The AWS Organization with all the accounts | `any` | n/a | yes |
| <a name="input_gd_publishing_dest_bucket_arn"></a> [gd\_publishing\_dest\_bucket\_arn](#input\_gd\_publishing\_dest\_bucket\_arn) | The bucket ARN to publish GD findings | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_detector"></a> [guardduty\_detector](#output\_guardduty\_detector) | The GuardDuty detector. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
