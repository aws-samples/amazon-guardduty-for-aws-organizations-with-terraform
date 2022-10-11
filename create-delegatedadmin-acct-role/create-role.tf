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

resource "aws_iam_role" "GuardDutyTerraformSecurityAcctRole" {
  name = "GuardDutyTerraformOrgRole"

  # Set the Trusted principal to the Management account
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowAssumeRole"
        Principal = {
          "AWS" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM definitions for GuardDutyTerraformOrgRole for the security account
data "aws_iam_policy_document" "security_acct_pol" {

  statement {
    sid    = "AllowGDPerms"
    effect = "Allow"
    actions = [
      "guardduty:CreateDetector",
      "guardduty:GetDetector",
      "guardduty:DeleteDetector",
      "guardduty:DescribeOrganizationConfiguration",
      "guardduty:UpdateOrganizationConfiguration",
      "guardduty:CreatePublishingDestination",
      "guardduty:DescribePublishingDestination",
      "guardduty:DeletePublishingDestination",
      "guardduty:CreateMembers",
      "guardduty:InviteMembers",
      "guardduty:DeleteMembers",
      "guardduty:GetMembers",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeRegions"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    sid    = "AllowKMS"
    effect = "Allow"
    actions = [
      "kms:ListGrants",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:ListKeys",
      "kms:ListResourceTags",
      "kms:GetKeyRotationStatus",
      "kms:PutKeyPolicy",
      "kms:ScheduleKeyDeletion",
      "kms:GenerateDataKey",
      "kms:CreateKey",
      "kms:EnableKeyRotation",
      "kms:CreateAlias",
      "kms:ListAliases",
      "kms:DeleteAlias"
    ]
    resources = [
      "*"
    ]
    condition {
      test = "StringEquals"
      variable = "kms:CallerAccount"
      values = [var.delegated_admin_acc_id]
    }
  }
  statement {
    sid       = "AllowIamPerms"
    effect    = "Allow"
    actions   = ["iam:GetRole"]
    resources = ["arn:aws:iam::*:role/aws-service-role/*guardduty.amazonaws.com/*"]
  }
  statement {
    sid       = "AllowSvcLinkedRolePerms"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:aws:iam::*:role/aws-service-role/*guardduty.amazonaws.com/*"]
    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["guardduty.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "gd_terraform_security_acct_policy" {
  name   = "gd_terraform_security_acct_policy"
  policy = data.aws_iam_policy_document.security_acct_pol.json
}

resource "aws_iam_role_policy_attachment" "attach_gd_terraform_security_acct_policy" {
  role       = aws_iam_role.GuardDutyTerraformSecurityAcctRole.name
  policy_arn = aws_iam_policy.gd_terraform_security_acct_policy.arn
}

