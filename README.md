
## Implementing Amazon GuardDuty for AWS Organizations organization using Terraform

#### Version 1.1.0

### Abstract
Sample Infrastructure-as-Code in Terraform to enable Amazon GuardDuty for the given AWS Organizations organization. This artefact uses the Auto-Enable feature of GuardDuty to enrol newly created member accounts into GuardDuty's administration structure, while also turning on GuardDuty in all existing members. This artefact does not use the Member-invite based method.

A runbook with steps to turn off Amazon GuardDuty which was setup using the Member-Invite based method has been provided (Runbook-for-turning-off-Amazon-GuardDuty-in-Member-Invite-method.docx). This can be used to turn off the Member-invite based model before using the given codebase to deploy GuardDuty using the Organizations-based method. 

Additional features include:
- Allows for the Security account as the Delegated Admin 
- Creates the Amazon S3 bucket and AWS KMS key to publish findings in the Logging/Compliance Account, along with lifecycle policy to transition to Amazon S3 Glacier
- Allows selecting regions to enable GuardDuty

### Target Audience
Security Engineers/Admins, Landing zone admins who want to deploy GuardDuty across multiple regions within an organization using Terraform.

### Prerequisites

You will need to complete the following prerequisites before proceeding with the steps to setup:

1) Terraform:
Terraform installed and ready to use. Follow the steps under https://www.Terraform.io/downloads.html for installation. The sample code provided has been tested with Terraform version v0.14.6

2) Python:
Python is used for generating Terraform code to identify all the allowed regions where GuardDuty can be enabled in the Delegated Administrator account. The sample code provided has been tested with Python v3.9.6.

3) Terraform State Remote Backend:
    - Create an S3 bucket for storing Terraform's remote backend state. Set the name as value for the configuration field "tfm_state_backend_s3_bucket" in [configuration.json.sample](configuration.json.sample).

    - Create an Amazon DynamoDB table, with the appropriate name in the same region as the S3 bucket. The table's primary key should be LockID of type String (other settings at default values). Set the name as value for the configuration field "tfm_state_backend_dynamodb_table" in [configuration.json.sample](configuration.json.sample).

4) Others:
    - GuardDuty should not already be enabled in any of the accounts, in any of the chosen regions.
    - An AWS Organizations organization with minimally three AWS accounts - designated as Management, Security and Logging accounts as per AWS Landing Zone best practices
        - A Management account: this is the account from which you will deploy the Terraform code, either stand-alone or as part of the CI/CD pipeline
        - A Security services account: this is the Delegated Admin for GuardDuty
        - A Logging account: this account houses the S3 bucket where the GuardDuty service will upload findings, if any

### Steps to setup

1) IAM Roles:

    - The setup process has to be run from the Management account of the organization with a dedicated IAM role created for this purpose. Create an IAM role in the Management account with the restricted policies provided [here](https://github.com/aws-samples/amazon-guardduty-for-aws-organizations-with-terraform/blob/main/management-account-role-policy.json). This role has the permissions for the entity (human or CI/CD pipeline) in the Management account to perform the rest of the actions required to enable GuardDuty in that organization using Terraform.  

    - Create IAM roles in the Security and Logging accounts with permissions to "Create IAM Role, IAM policy and attach policies". The management account should be set as Trusted Principal for both the roles. The setup assumes that both roles have the same 'name', which is then set as value for the configuration field "role_to_assume_for_role_creation" in [configuration.json.sample](configuration.json.sample). The Terraform code assumes these roles to create dedicated IAM roles in the Security and Logging accounts. Alternatively, the OrganizationAccountAccessRole (if present) can also be used for this instead.

2) Terraform Variable Values:

    - All Terraform Variables are exported as [environment variables](https://www.terraform.io/language/values/variables#environment-variables) with the prefix 'TF_VAR_' before the Terraform code execution begins.
    - Fill in the appropriate values for all the fields in [configuration.json.sample](configuration.json.sample). Rename the file as **configuration.json**. The various configuration items are explained below:

    ```json
    {
        "delegated_admin_acc_id" : Account ID for the Security Account,
        "logging_acc_id" : Account ID for the Logging Account,
        "target_regions" : Comma-separated list of AWS regions where GuardDuty is to be enabled,
        "organization_id" : AWS Organizations ID for the organization where GuardDuty is to be enabled,
        "default_region" : Default region of operation,
        "role_to_assume_for_role_creation" : IAM role name in the Security and Logging accounts, that will be assumed to create the necessary Guardduty roles; same name to be used in both accounts,   
        "finding_publishing_frequency" : Frequency at which GuardDuty findings are published,
        "guardduty_findings_bucket_region" : Preferred region where the GuardDuty publishing destination S3 bucket is to be created,
        "logging_acc_s3_bucket_name" : Preferred name for the GuardDuty publishing destination S3 bucket,
        "logging_acc_kms_key_alias" : AWS KMS CMK alias for the key used to encrypt GuardDuty findings,
        "s3_access_log_bucket_name" : Name of a pre-existing S3 bucket to be used for collecting access logs for the GuardDuty publishing destination S3 bucket,
        "tfm_state_backend_s3_bucket" : Name of the pre-existing S3 bucket to store Terraform's remote backend state,
        "tfm_state_backend_dynamodb_table" : Name of the pre-existing DynamoDB table for locking Terraform state,
        "tfm_state_region" : AWS Region where both the remote backend state S3 bucket and DynamoDB table are present
    }
    ```

3) Setup all resources:

    From the project root folder run the following command via CLI or as part of the build specifications:
    ```bash
    bash scripts/full-setup.sh
    ```
    This sets up all the IAM roles, configures the environment variables with values from step 2, generates code for the backend.tf files, imports the organization into Terraform state and generates code for enabling GuardDuty in the allowed regions.

### Clean-up
1) From the project root folder run the following command via CLI:
    ```bash
    bash scripts/cleanup-gd.sh
    ```
All previously deployed resources will be cleaned-up, except for the organization state that was imported into the *[import-org](import-org/)* Terraform module's state.

### Region Selection for enabling GuardDuty

1) AWS GuardDuty is available in several regions. This is obtained as a list via an API call in the Python script.
2) The Delegated Administrator account has its own list of allowed regions i.e., regions which are not *disabled* and are either opted in by the account owner or opt-in is not required. This is obtained as a separate list via another API call.
3) The intersection of the lists from (2) and (3) provide us with an "allowed list" of regions where GuardDuty can be enabled without errors. 
4) There is a configuration field "target_regions" in [configuration.json.sample](configuration.json.sample) which is a comma-separated list of preferred regions where GuardDuty needs to be enabled in the current organization. Each region specified in the "target_regions" configuration is compared with the "allowed list" from (3) before proceeding to enable GuardDuty in those preferred regions.

### Detailed Code Documentation

#### Components Included
- Terraform Code *import-org* - to store the resource config of the imported AWS Organization
- Terraform Code *create-delegatedadmin-acct-role* - to create role for the Management account to assume in the Security account
- Terraform Code *create-logging-acct-role* - to create role for the Management account to assume in the Logging account
- Terraform Module *guardduty-baseline* - to store the resource config of the GuardDuty resource for one region
- Terraform Module *s3-bucket-create* - to create an S3 bucket and KMS key in the logging account to store 
GuardDuty findings; also has a lifecycle policy to transition items to Glacier after 'n' days
- Root-level Terraform file *tfm-findings-store* - to invoke the *s3-bucket-create* module
- Root-level Terraform file *tfm-gd-enabler* - to enable GuardDuty for different regions
- management-account-role-policy.json - Policy applied to the Pipeline role in the Management account
- CLI scripts under *scripts/* - To automate the entire process from the CLI

#### Resources created (list is not exhaustive)
- S3 bucket for GuardDuty findings
- KMS key for encrypting the S3 bucket and an alias for the key
- S3 lifecycle policy to move findings to S3 Glacier after 'n' days
- GuardDuty Detectors for each of the accounts in each target region
- Delegated admin to designate the Security account as admin for GuardDuty
- Relevant IAM roles and policies for all the above

#### Scripts
The scripts provided under scripts/ folder are used to automate the entire process. 

- **[scripts/full-setup.sh](scripts/full-setup.sh)**:
    - Main script to setup the entire workflow
- **[scripts/cleanup-gd.sh](scripts/cleanup-gd.sh)**:
    - Script to cleanup all the resources setup with scripts/full-setup.sh except importing the org

##### Internal scripts
- **[scripts/generate-backend.sh](scripts/generate-backend.sh)**:
    - Internal Script used by scripts/full-setup.sh to generate code for backend.tf files
- **[scripts/create-roles.sh](scripts/create-roles.sh)**: 
    - Internal Script used by scripts/full-setup.sh to create IAM roles
- **[scripts/setup-gd.sh](scripts/setup-gd.sh)**:
    - Internal Script used by scripts/full-setup.sh to import org and enable GuardDuty

#### Outputs
The following outputs are generated from the module *tfm-gd-enabler*:
- guardduty_detector - The GuardDuty detector ID in each region.

#### Additional Notes
##### How to add support for new regions to deploy GuardDuty?
Add the new region(s) to the "target_region" configuration field in [configuration.json.sample](configuration.json.sample) file and follow the steps in [Steps to setup](#steps-to-setup)

##### Handling addition of new members:
- Once GuardDuty is enabled in the Organization, new members are automatically included in the purview of the Delegated admin.
- GuardDuty is automatically turned on in the new member account and other settings are configured. 
- In order to selectively update the state in Terraform, do the following:
    - Under import_org/ run terraform plan, check that the new accounts are included in the state and there are no other changes; then run terraform apply
    - Under enable-gd/ run terraform plan, check that the new accounts are included in the state and there are no other changes; then run terraform apply

##### Notes on the service:
- GuardDuty only incurs charges when there is actual activity in an AWS region.
- This code can only be applied once per AWS account. Attempts to deploy the module multiple times will lead to failures during Terraform apply, due to the nature of the service.
- The actual time for the findings to arrive at the S3 bucket in the Logging account may vary depending on many conditions.

#### Troubleshooting

##### Success criteria:
If there are no errors during the above deployment process, the following can be observed via the Console:
- The S3 bucket would be created with the KMS key in the Logging Account.
- GuardDuty would be setup in the Organization with the Security account as Delegated Administrator. The S3 bucket is configured to collect GuardDuty findings.
- All existing member accounts would be enrolled as members within the Accounts of the Security account and GuardDuty would be turned ON in these accounts.
- All newly created member accounts would have GuardDuty automatically enabled.
- S3 Protection will be turned ON by default in all existing and new member accounts.
- Individual member accounts cannot suspend or disable GuardDuty by themselves.

##### Known errors:
- For subsequent runs of the steps to deploy after the first run, a known error will be reported about importing and already imported resource for the import-org module. Though this is shown as an 'Error', this is expected behavior and does not affect the rest of the setup, so it can be ignored.

## Contributing
Thanks for your interest in contributing! There are many ways to contribute to this project. Get started with [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications).

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

