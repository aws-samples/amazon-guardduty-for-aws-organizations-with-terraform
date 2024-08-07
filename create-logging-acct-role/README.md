# create-logging-acct-role

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region of operation | `any` | n/a | yes |
| <a name="input_logging_acc_id"></a> [logging\_acc\_id](#input\_logging\_acc\_id) | The account id of the management account. | `any` | n/a | yes |
| <a name="input_role_to_assume_for_role_creation"></a> [role\_to\_assume\_for\_role\_creation](#input\_role\_to\_assume\_for\_role\_creation) | Terraform will assume this IAM role to create the infra in this module | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Specifies object tags key and value. This applies to all resources created by this module. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logging_acct_role_to_assume"></a> [logging\_acct\_role\_to\_assume](#output\_logging\_acct\_role\_to\_assume) | The role name in the Logging/Compliance account. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
