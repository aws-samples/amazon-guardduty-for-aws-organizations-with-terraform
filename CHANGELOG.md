# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Updated scripts to work with Amazon Linux 2023

### Changed

- Reformat markdown files for compliance

## [1.4.0] - 2023-05-04

### Fixed

- Enabled service access principal for GuardDuty separately and not via import-org

### Removed

- `terraform apply` option for import-org

## [1.3.0] - 2022-10-10

### Added

- Automation to dynamically update `guardduty.amazonaws.com` to the list of service access principals in the organization; prior to this update this was to be done manually

### Changed

- Aligned with the AWS SRA to re-locate the KMS key to the security account; prior to this change this key was created in the logging account

### Fixed

- Updated required version from `= 0.14.6` to `>= 0.14.6` to add support for higher versions of Terraform; tested with version `1.2.8`

## [1.2.0] - 2022-07-30

### Added

- CloudFormation templates to create IAM roles in the management account
- Scripts to populate the templates with values in configuration file
- Script `generate-tfvars.sh` to generate backend.tf and terraform.tfvars code files for each Terraform module

### Fixed

- Updated scripts to work on Amazon Linux 2

## [1.1.0] - 2022-02-03

### Added

- Configuration file with default values
- Script to perform full setup
- Terraform code generation of python scripts to dynamically generate GuardDuty-enabled code for allowed regions

### Changed

- Consoldated to a 2-step deploy

### Removed

- Hardcoded regions list and added api calls to create the 'allowed' regions list from an intersection of regions where GuardDuty is available and another list of regions that are enabled and opted in for the delegated administrator account

## [1.0.0] - 2021-07-04

- Initial version
