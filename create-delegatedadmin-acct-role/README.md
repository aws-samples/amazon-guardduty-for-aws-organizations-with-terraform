# create-delegatedadmin-acct-role

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.gd_terraform_security_acct_policy](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.GuardDutyTerraformSecurityAcctRole](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_gd_terraform_security_acct_policy](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.security_acct_pol](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region of operation | `any` | n/a | yes |
| <a name="input_delegated_admin_acc_id"></a> [delegated\_admin\_acc\_id](#input\_delegated\_admin\_acc\_id) | The account id of the management account. | `any` | n/a | yes |
| <a name="input_role_to_assume_for_role_creation"></a> [role\_to\_assume\_for\_role\_creation](#input\_role\_to\_assume\_for\_role\_creation) | Terraform will assume this IAM role to create the infra in this module | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_acct_role_to_assume"></a> [security\_acct\_role\_to\_assume](#output\_security\_acct\_role\_to\_assume) | The role name in the Security account. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
