
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

# GD Findings Bucket policy
data "aws_iam_policy_document" "bucket_pol" {
  statement {
    sid = "Allow PutObject"
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.gd_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "AWSBucketPermissionsCheck"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.gd_bucket.arn
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid    = "Deny unencrypted object uploads. This is optional"
    effect = "Deny"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.gd_bucket.arn}/*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "aws:kms"
      ]
    }
  }

  statement {
    sid    = "Deny incorrect encryption header. This is optional"
    effect = "Deny"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.gd_bucket.arn}/*"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"

      values = [
        aws_kms_key.gd_key.arn
      ]
    }
  }

  statement {
    sid    = "Deny non-HTTPS access"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.gd_bucket.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }

  statement {
    sid    = "Access logs ACL check"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      aws_s3_bucket.gd_bucket.arn
    ]
  }

  statement {
    sid    = "Access logs write"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.gd_bucket.arn,
      "${aws_s3_bucket.gd_bucket.arn}/AWSLogs/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

# GD Findings bucket KMS CMK policy
data "aws_iam_policy_document" "kms_pol" {

  statement {
    sid = "Allow use of the key for guardduty"
    actions = [
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:DescribeKey"
    ]

    resources = [
      "arn:aws:kms:${var.default_region}:${var.delegated_admin_acc_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
  }

  statement {
    sid = "Allow attachment of persistent resources for guardduty"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]

    resources = [
      "arn:aws:kms:${var.default_region}:${var.delegated_admin_acc_id}:key/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        "true"
      ]
    }
  }

  statement {
    sid = "Allow all KMS Permissions for root account of GD Admin"
    actions = [
      "kms:*"
    ]

    resources = [
      "arn:aws:kms:${var.default_region}:${var.delegated_admin_acc_id}:key/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.delegated_admin_acc_id}:root"]
    }
  }

  statement {
    sid = "Allow access for Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    resources = [
      "*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"]
    }
  }
}

# KMS CMK to be created to encrypt GD findings in the S3 bucket
resource "aws_kms_key" "gd_key" {
  provider                = aws.key
  description             = "GuardDuty findings encryption CMK"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_pol.json
  tags                    = var.tags
}

resource "aws_kms_alias" "kms_key_alias" {
  provider      = aws.key
  name          = "alias/${var.kms_key_alias}"
  target_key_id = aws_kms_key.gd_key.key_id
}

# GD findings S3 bucket to be created
resource "aws_s3_bucket" "gd_bucket" {
  provider   = aws.src
  depends_on = [aws_kms_key.gd_key]
  bucket     = var.s3_logging_bucket_name

  acl           = "private"
  force_destroy = true

  logging {
    target_bucket = var.s3_access_log_bucket_name
    target_prefix = "log/"
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.gd_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "transition-objects-to-glacier"
    enabled = var.s3_bucket_enable_object_transition_to_glacier
    transition {
      days          = var.s3_bucket_object_transition_to_glacier_after_days
      storage_class = "GLACIER"
    }
  }
  lifecycle_rule {
    id      = "delete-objects"
    enabled = var.s3_bucket_enable_object_deletion
    expiration {
      days = var.s3_bucket_object_deletion_after_days
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "gd_bucket_block_public" {
  depends_on              = [aws_s3_bucket.gd_bucket, aws_s3_bucket_policy.gd_bucket_policy]
  bucket                  = aws_s3_bucket.gd_bucket.id
  provider                = aws.src
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "gd_bucket_policy" {
  depends_on = [aws_s3_bucket.gd_bucket]
  provider   = aws.src
  bucket     = aws_s3_bucket.gd_bucket.id
  policy     = data.aws_iam_policy_document.bucket_pol.json
}
