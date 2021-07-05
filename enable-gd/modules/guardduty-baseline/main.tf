
locals {
  mem_accounts = var.gd_my_org.accounts
  deleg_admin  = var.gd_delegated_admin_acc_id
  temp = [
    for x in local.mem_accounts :
    x if x.id != local.deleg_admin && x.status == "ACTIVE"
  ]
}

# GuardDuty Detector in the Delegated admin account
resource "aws_guardduty_detector" "MyDetector" {
  provider   = aws.dst
  depends_on = [var.gd_my_org]

  count = var.enabled ? 1 : 0

  enable                       = true
  finding_publishing_frequency = var.gd_finding_publishing_frequency

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

  auto_enable = true
  detector_id = aws_guardduty_detector.MyDetector[0].id
}

# GuardDuty members in the Delegated admin account
resource "aws_guardduty_member" "members" {
  provider   = aws.dst
  depends_on = [aws_guardduty_organization_configuration.MyGDOrg]

  count = var.enabled ? length(local.temp) : 0

  detector_id = aws_guardduty_detector.MyDetector[0].id
  invite      = true

  account_id                 = local.temp[count.index].id
  disable_email_notification = true
  email                      = local.temp[count.index].email

  lifecycle {
    ignore_changes = [
      email
    ]
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