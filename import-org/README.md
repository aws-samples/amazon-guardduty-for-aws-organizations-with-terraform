# import-org

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.src"></a> [aws.src](#provider\_aws.src) | 3.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.my_org](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/organizations_organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region of operation | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_my_org"></a> [my\_org](#output\_my\_org) | n/a |
| <a name="output_org_id"></a> [org\_id](#output\_org\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
