
## Amazon GuardDuty deployment for AWS Organizations using Terraform

### Version 1.0.0

### Abstract
Infrastructure-as-Code in Terraform to enable Amazon GuardDuty for the given AWS Organizations organization. This artefact uses the Auto-Enable feature of GuardDuty to enroll newly created member accounts into GuardDuty's administration structure, while also turning on GuardDuty in all existing members. This artefact does not use the Member-invite based method.

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
- GuardDuty Detetors for each of the accounts in each of the selected regions
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
- The regions included are those that support GuardDuty deployment as of May 2021.

### Prerequisites

#### Terraform Installation:
Follow the steps under https://www.terraform.io/downloads.html

#### Terraform Version:
Terraform version v0.14.6

#### Terraform State Remote Backend:
- Create the S3 bucket for the remote backend; the bucket name has to match the name in the backend config (tfm-guardduty-enabler/main.tf) in the default region. Same bucket is also used to store the imported Organization state.

- Create a DynamoDB table, with the appropriate name. The table's primary key should be LockID of type String (other settings at default values).

#### IAM Roles creation in the Management, Logging/Compliance and Security accounts:
- Update the variables.tf files under all the folders as appropriate. 

- Create a role in the Management account using the policy in management-account-policy.json. Set the temporary credentials for this role as environment variables for Access Key ID, Secret Access Key and Session Token.

- Use the attached *create-delegatedadmin-acct-role/create-role.tf* to create the *'GuardDutyTerraformOrgRole'* in the Security account (this account acts as the Delegated admin for GuardDuty). Provide the Management account id as input when doing *terraform apply*. 

- Use the attached create-logging-acct-role/create-role.tf to create the *'GuardDutyTerraformOrgRole'* in the Logging/Compliance account (this account has the S3 bucket with GuardDuty findings). Provide the Management account id as input when doing *terraform apply*. 

- These roles in the Security and Logging accounts will have the Management account as Trusted Entity.


#### Terraform Variable Values:
- The Access key and Secrets for the Management account Pipeline role are not hardcoded into the Terraform code explicitly. The code has to be deployed with the role created in the Management account; the credentials can be set via AWS ENV variables before proceeding (See IAM role-related prerequisites)

- In the *create-gd-bucket-and-key* folder, update the *variables.tf* file with the appropriate values; the default values are already filled in as below:
    ```terraform
    logging_acc_id = "<AWS-Account-ID>"
    assume_role_name = "GuardDutyTerraformOrgRole"
    default_region = "ap-southeast-1"
    tags = { 
        Project = "MyProject"
        Scope = "PROD"
    }
    logging_acc_kms_key_alias    = "<preferred alias for KMS key used to encrypt logs at rest>"
    logging_acc_s3_bucket_name   = "<preferred name for S3 bucket where logs get published>"
    lifecycle_policy_days = "365"
    ```
- In the *enable-gd* folder, update the *variables.tf* file with the appropriate values; the default values are already filled in as below:

    ```terraform
    delegated_admin_acc_id = "<AWS-Account-ID>"
    assume_role_name = "GuardDutyTerraformOrgRole"
    target_regions=["ap-southeast-1"...]
    tags = { 
        Project = "MyProject"
        Scope = "PROD"
    }
    finding_publishing_frequency = "FIFTEEN_MINUTES"
    ```
The default region is the first item (or the item at the 0th index) in the *target_regions* list.

### Actual Steps
1) Import the existing organization to Terraform state:
    - Run *terraform init* under the folder import-org/.
    - Run this command:
*terraform import aws_organizations_organization.my_org ORG-ID*
  This imports the existing organization state into Terraform and configures the remote state separately within the same S3 bucket, but a different state file.
    - For subsequent *terraform plan*, observe the plan output for any changes to the organization config, particularly around the *aws_service_access_principals*
    - If Terraform highlights these as changed, update the module's resource config in the terraform code to include the relevant service principals.
    - For example, you may need to minimally add the following to import-org/main.tf after a successful import:

    ```terraform
    feature_set = "ALL"

    aws_service_access_principals = [
        "cloudtrail.amazonaws.com",
        "guardduty.amazonaws.com"
    ]
    ```
#### Note: Failure to do this step, might result in the organization's configuration getting modified.

    - GuardDuty should be enabled in the Organization Policies. The resource config for the Organization has already been provided under import-org/.
    - Run *terraform apply* to commit the state to the state file. 
    - After the import, the organization can be manipulated using Terraform, so watch out for hasty destroys or other changes to the Organization settings within this folder. 

2) Create the GuardDuty findings bucket:
    - Move to the folder *create-gd-bucket-and-key/*
    - Perform *terraform init*, *terraform plan* and *terraform apply*
    - Validate the outputs from this module; these will be used as inputs for the next step

3) Enable GuardDuty in all regions under the Organization: 
    - Move to the folder *enable-gd/*
    - Perform *terraform init*, *terraform plan* and *terraform apply*
    - While testing, if there are any changes to code in the sub-modules, re-run *terraform init*

5) *terraform destroy* can be used to destroy the GuardDuty-specific resources created previously.

#### The same steps have been captured as shell scripts under the scripts/ folder

### Outputs
The following items are generated as outputs from the root-level module (tfm-gd-enabler):
- guardduty_detector - The GuardDuty detector ID in each region.

### Regions Supported
The module can setup GuardDuty in the 23 regions listed below:
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-south-1",
    "ca-central-1",
    "eu-central-1",
    "eu-north-1",
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "sa-east-1",
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",

Opt-in regions:
    "af-south-1",
    "ap-northeast-3",
    "ap-east-1",
    "cn-north-1",
    "cn-northwest-1",
    "eu-south-1",
    "me-south-1"

However, the actual region(s) for deployment is chosen from the *target_regions* list.


#### Additional Notes
##### How to add support for new regions to deploy GuardDuty?
- Edit the following files to add configuration for each new region:
    - providers.tf
    - tfm-gd-enabler.tf
    - variables.tf

##### Handling addition of new members:
- Once GuardDuty is enabled in the Organization, new members are automatically included in the purview of the Delegated admin.
- GuardDuty is automatically turned on in the new member account and other settings are configured. 
- In order to update the state in Terraform, do the following:
    - Under import_org/ run terraform plan, check that the new accounts are included in the state and there are no other changes; then run terraform apply
    - Under enable-gd/ run terraform plan, check that the new accounts are included in the state and there are no other changes; then run terraform apply

##### Turning on S3 protection for GuardDuty:
- This is currently not supported via Terraform, with a pending feature request. 
- Until the feature is available, use the instructions under https://docs.aws.amazon.com/guardduty/latest/ug/s3_detection.html to turn on S3 protection in GuardDuty. This should be performed after setting up GuardDuty.

#### Troubleshooting:
##### Success criteria:
If there are no errors during the above deployment process, the following can be observed via the Console:
- The S3 bucket would be created with the KMS key in the Logging Account.
- GuardDuty would be setup in the Organization with the Security account as Delegated Administrator. The S3 bucket is configured to collect GuardDuty findings.
- All existing member accounts would be enrolled as members within the Accounts of the Security account and GuardDuty would be turned ON in these accounts.
- All newly created member accounts would have GuardDuty automatically enabled.
- Individual member accounts cannot suspend or disable GuardDuty by themselves.

##### Potential Errors encountered:
Error: error deleting S3 Bucket Public Access Block (<bucket-name>): OperationAborted: A conflicting conditional operation is currently in progress against this resource. Please try again.
If this error is observed during bucket operations, retry the terraform apply once again.

## Contributing
Thanks for your interest in contributing! There are many ways to contribute to this project. Get started with [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications).

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

