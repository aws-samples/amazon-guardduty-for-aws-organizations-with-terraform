Ver 1.0.0 - Initial version

Ver 1.1.0 - 
 - Consolidated 'Steps to deploy' to two steps:
    - Add configuration values to a configuration file and 
    - Run a script that does full setup. 
 - Added Terraform code generation python scripts to dynamically generate GuardDuty enabled code for allowed regions. 
 - Removed hardcoded regions list and added api calls to create the 'allowed' regions list from an intersection of regions where GuardDuty is available and another list of regions that are enabled and opted in for the delegated administrator account

Ver 1.2.0 - 
- Aligned with APG pattern to add CloudFormation templates to create IAM roles in the management, security and logging accounts; added scripts to populate the templates with values in configuration file
- Added script 'generate-tfvars.sh' to generate backend.tf and terraform.tfvars code files for each Terraform module
- Updated scripts to work on Amazon Linux 2

Ver 1.3.0 - 
- Updated required version from '= 0.14.6' to '>= 0.14.6' to add support for higher versions of Terraform; tested with version 1.2.8
- Added automation to dynamically update 'guardduty.amazonaws.com' to the list of service access principals in the organization; prior to this update this was to be done manually
- Aligned with the AWS SRA to re-locate the KMS key to the security account; prior to this change this key was created in the logging account