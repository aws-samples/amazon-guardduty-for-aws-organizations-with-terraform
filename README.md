
## Amazon GuardDuty deployment for AWS Organizations using Terraform

### Version 1.1.0

### Abstract
Infrastructure-as-Code in Terraform to enable Amazon GuardDuty for the given AWS Organizations organization. This artefact uses the Auto-Enable feature of GuardDuty to enroll newly created member accounts into GuardDuty's administration structure, while also turning on GuardDuty in all existing members. This artefact does not use the Member-invite based method.

**UPDATE** - A runbook with steps to turn off Amazon GuardDuty which was setup using the Member-Invite based method has been provided (Runbook-for-turning-off-Amazon-GuardDuty-in-Member-Invite-method.docx). This can be used to turn off the Member-invite based model before using the given codebase to deploy GuardDuty using the Organizations-based method. 

Additional features include:
- Allows for the Security account as the Delegated Admin 
- Creates the Amazon S3 bucket and AWS KMS key to publish findings in the Logging/Compliance Account, along with lifecycle policy to transition to Amazon S3 Glacier
- Allows selecting regions to enable GuardDuty

### Target Audience
Security Engineers/Admins who want to deploy GuardDuty across multiple regions within an Organization using Terraform.

### Assumptions
1) There is an AWS Organizations organization present with at least 3 accounts (designated as Management, Security and Logging accounts as per AWS Landing Zone best practices).
2) There is a Security services account (this would be the Delegated Admin for GuardDuty).
3) There is a Logging/Compliance account (this is where GuardDuty findings will be uploaded in the default region).

### Components Included
- Terraform Code *import-org* - to store the resource config of the imported AWS Organization
- Terraform Code *create-delegatedadmin-acct-role* - to create role for the Management account to assume in the Security account
- Terraform Code *create-logging-acct-role* - to create role for the Management account to assume in the Logging account
- Terraform Module *guardduty-baseline* - to store the resource config of the GuardDuty resource for one region
- Terraform Module *s3-bucket-create* - to create an S3 bucket and KMS key in the logging account to store 
GuardDuty findings; also has a lifecycle policy to transition items to Glacier after 'n' days
- Root-level Terraform file *tfm-findings-store* - to invoke the *s3-bucket-create* module
- Root-level Terraform file *tfm-gd-enabler* - to enable GuardDuty for different regions
- management-account-policy.json - Policy applied to the Pipeline role in the Management account
- CLI scripts under *scripts/* - To automate the entire process from the CLI

### Resources created (list is not exhaustive)
- S3 bucket for GuardDuty findings
- KMS key for encrypting the S3 bucket and an alias for the key
- S3 lifecycle policy to move findings to S3 Glacier after 'n' days
- GuardDuty Detectors for each of the accounts in each target region
- Delegated admin to designate the Security account as admin for GuardDuty
- Relevant policies for all the above

### To Note
Please note the following additional aspects:
- GuardDuty only incurs charges when there is actual activity in an AWS region.
- As GuardDuty is a central service, this code can only be applied once per AWS account. Attempts to deploy the module multiple times will lead to failures during Terraform apply. 
- GuardDuty should not already be enabled in the accounts.
- The IAM roles in the Security and Logging accounts are to be created before running the GuardDuty root-level module. These roles in the other accounts must have the Management account as Trusted Entity.
- The root-level terraform code has to be run from the Management account of the organization, since the Delegated admin can only be set from the Management account. The policy for the Pipeline role used to run this code has been provided under management-account-policy.json.
- The actual time for the findings to arrive at the S3 bucket in the Logging account may vary depending on many conditions.

### Prerequisites

#### Terraform Installation:
Follow the steps under https://www.terraform.io/downloads.html

#### Terraform Version:
Terraform version v0.14.6

#### Python Version:
Python is needed for generating Terraform code based on identifying all the allowed regions where GuardDuty can be enabled in the Delegated Administrator account. The latest version of Python used for testing is v3.9.6

#### Terraform State Remote Backend:
- Create an S3 bucket for storing terraform's remote backend state. Set the name as value for the configuration field "tfm_state_backend_s3_bucket" in configuration.json.sample. This step is a prerequisite before setup can begin.

- Create a DynamoDB table, with the appropriate name in the same region as the S3 bucket. The table's primary key should be LockID of type String (other settings at default values). Set the name as value for the configuration field "tfm_state_backend_dynamodb_table" in configuration.json.sample. This step is a prerequisite before setup can begin.

#### IAM Roles creation:

Create a role in the Security and Logging accounts with permissions to Create IAM Role and additionally IAM policy. The management account should be set as Trusted Principal for both the roles. The setup assumes that both Roles have the same 'name', which is then set as value for the configuration field "role_to_assume_for_role_creation" in configuration.json.sample. This step is a prerequisite before setup can begin.

#### Terraform Variable Values:

All Terraform Variables are exported as [environment variables](https://www.terraform.io/language/values/variables#environment-variables) with the prefix 'TF_VAR_' before the terraform code execution begins.
A sample configuration JSON file is provided that needs to be populated with preferred values before setup can begin.
```json
{
    "delegated_admin_acc_id" : Account ID for the Security Account,
    "logging_acc_id" : Account ID for the Logging Account,
    "target_regions" : eu-north-1,ap-south-1,eu-west-3,eu-west-2,eu-west-1,ap-northeast-3,ap-northeast-2,ap-northeast-1,sa-east-1,ca-central-1,ap-southeast-1,ap-southeast-2,eu-central-1,us-east-1,us-east-2,us-west-1,us-west-2,
    "organization_id" : AWS Organizations ID for the organization where GuardDuty needs enabling,
    "default_region" : Default region of operation when creating Roles,
    "role_to_assume_for_role_creation" : Name of the role provided as input that will be assumed to create the necessary guardduty roles by terraform,

    "finding_publishing_frequency" : Frequency at which GuardDuty findings are published,
    "guardduty_findings_bucket_region" : Preferred region where the GuardDuty findings bucket should be created,
    "logging_acc_s3_bucket_name" : Preferred name for the GuardDuty findings bucket,
    "logging_acc_kms_key_alias" : KMS Key alias for the key that will be used as CMK for encrypting GuardDuty findings,
    "s3_access_log_bucket_name" : Name of a bucket to be used for collecting access logs for the GuardDuty findings bucket,

    "tfm_state_backend_s3_bucket" : Name of S3 bucket to store terraform's remote backend state,
    "tfm_state_backend_dynamodb_table" : DyanmoDB table for store terraform state,
    "tfm_state_region" : Region where both the backend S3 bucket and DynamoDB table are created
}
```

### Scripts
The scripts provided under scripts/ folder can be used to automate the entire process. The detailed actions have been elaborated under the [Steps to deploy](#steps-to-deploy) section. The following scripts have been provided:
- **[scripts/create-roles.sh](scripts/create-roles.sh)**: 
    - Script to implement steps 3 and 4 of [IAM Roles creation](#iam-roles-creation)
    - Steps 1 and 2 of [IAM Roles creation](#iam-roles-creation) have to be done manually as prerequisites
- **[scripts/setup-gd.sh](scripts/setup-gd.sh)**:
    - Script to implement actions in [Steps to deploy](#steps-to-deploy)
    - There are still some manual steps to be done like filling in the variables.tf files and actions relating to importing the Organization
- **[scripts/destroy-gd.sh](scripts/destroy-gd.sh)**:
    - Script to delete all actions, except importing the org, from [Steps to deploy](#steps-to-deploy)
- **[scripts/generate-backend.sh](scripts/generate-backend.sh)**:
    - Script to generate the backend.tf file for each terraform module
- **[scripts/full-setup.sh](scripts/generate-backend.sh)**:
    - A single script to run the full setup

### Steps to deploy
1) Fill values for all the fields in configuration.json.sample. Rename the file as configuration.json
2) From the project root folder run the following command on a command-line interface:
```bash
bash scripts/full-setup.sh
```

### Steps to destroy
1) From the project root folder run the following command on a command-line interface:
From the project root folder run the following command:
```bash
bash scripts/destroy-gd.sh
```
All previously deployed entities will be destroyed when this script runs, except for the AWS Organization that was imported into the *[import-org](import-org/)* terraform module's state.

### Outputs
The following items are generated as outputs from the root-level module (tfm-gd-enabler):
- guardduty_detector - The GuardDuty detector ID in each region.

### Regions Supported
In terms of the regions supported, there are a few things to note.
1) There is a configuration field "target_regions" in [configuration.json.sample](configuration.json.sample) which is a comma-separated list of preferred regions where GuardDuty needs to be enabled.
2) AWS GuardDuty is available in several regions. This is obtained as a list via an API call in the code.
3) The Delegated Administrator account has its own list of allowed regions i.e. regions which are not *disabled* are are either opted in by the account owner or opt-in is not required.
The intersection of the lists from (2) and (3) provide us with an "allowed list" of regions where GuardDuty can be enabled without errors. Each region specified in the "target_regions" configuration is compared with the "allowed list" before proceeding to enable GuardDuty in those preferred regions.

#### Additional Notes
##### How to add support for new regions to deploy GuardDuty?
Add the new region(s) to the "target_region" configuration field in configuration.json.sample file and follow the steps in [Steps to deploy](#steps-to-deploy)

##### Handling addition of new members:
- Once GuardDuty is enabled in the Organization, new members are automatically included in the purview of the Delegated admin.
- GuardDuty is automatically turned on in the new member account and other settings are configured. 
- In order to update the state in Terraform, do the following:
    - Under import_org/ run terraform plan, check that the new accounts are included in the state and there are no other changes; then run terraform apply
    - Under enable-gd/ run terraform plan, check that the new accounts are included in the state and there are no other changes; then run terraform apply

#### Troubleshooting:
##### Success criteria:
If there are no errors during the above deployment process, the following can be observed via the Console:
- The S3 bucket would be created with the KMS key in the Logging Account.
- GuardDuty would be setup in the Organization with the Security account as Delegated Administrator. The S3 bucket is configured to collect GuardDuty findings.
- All existing member accounts would be enrolled as members within the Accounts of the Security account and GuardDuty would be turned ON in these accounts.
- All newly created member accounts would have GuardDuty automatically enabled.
- Individual member accounts cannot suspend or disable GuardDuty by themselves.

##### Known errors:
- For subsequent runs of the steps to deploy after the first run, a known error is seen for the import-org module, where Terraform will say that the organization has already been imported. Though this is shown as an 'Error', this is expected behavior but does not affect the rest of the setup and can be ignored.

## Contributing
Thanks for your interest in contributing! There are many ways to contribute to this project. Get started with [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications).

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

