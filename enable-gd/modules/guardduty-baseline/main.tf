#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#  SPDX-License-Identifier: MIT-0

#  Permission is hereby granted, free of charge, to any person obtaining a copy of this
#  software and associated documentation files (the "Software"), to deal in the Software
#  without restriction, including without limitation the rights to use, copy, modify,
#  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
#  permit persons to whom the Software is furnished to do so.

#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
#  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# GuardDuty Detector in the Delegated admin account
resource "aws_guardduty_detector" "MyDetector" {
  provider = aws.dst

  count = var.enabled ? 1 : 0

  enable                       = true
  finding_publishing_frequency = var.gd_finding_publishing_frequency

  # Additional setting to turn on S3 Protection
  datasources {
    s3_logs {
      enable = true
    }
  }
  tags = var.tags
}

# Organization GuardDuty configuration in the Management account
resource "aws_guardduty_organization_admin_account" "MyGDOrgDelegatedAdmin" {
  provider = aws.src

  depends_on = [aws_guardduty_detector.MyDetector]

  count = var.enabled ? 1 : 0

  admin_account_id = var.gd_delegated_admin_acc_id
}

# Organization GuardDuty configuration in the Delegated admin account
resource "aws_guardduty_organization_configuration" "MyGDOrg" {
  provider = aws.dst

  depends_on = [aws_guardduty_organization_admin_account.MyGDOrgDelegatedAdmin]
  count      = var.enabled ? 1 : 0

  auto_enable_organization_members = "ALL"
  detector_id                      = aws_guardduty_detector.MyDetector[0].id

  datasources {
    # Additional setting to turn on S3 Protection
    s3_logs {
      auto_enable = true
    }
  }
}

# GuardDuty Publishing destination in the Delegated admin account
resource "aws_guardduty_publishing_destination" "pub_dest" {
  provider   = aws.dst
  depends_on = [aws_guardduty_organization_admin_account.MyGDOrgDelegatedAdmin]

  count = var.enabled ? 1 : 0

  detector_id     = aws_guardduty_detector.MyDetector[0].id
  destination_arn = var.gd_publishing_dest_bucket_arn
  kms_key_arn     = var.gd_kms_key_arn
}
