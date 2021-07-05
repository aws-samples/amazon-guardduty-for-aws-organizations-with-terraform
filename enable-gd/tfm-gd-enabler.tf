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

# --------------------------------------------------------------------------------------------------
# GuardDuty enabler root module
# Needs to be set up in each region.
# --------------------------------------------------------------------------------------------------
locals {
  guardduty_admin_account_id             = var.delegated_admin_acc_id
  guardduty_finding_publishing_frequency = var.finding_publishing_frequency
  guardduty_findings_bucket_arn          = data.terraform_remote_state.guardduty_findings_store.outputs.guardduty_findings_bucket_arn
  guardduty_findings_kms_key_arn         = data.terraform_remote_state.guardduty_findings_store.outputs.guardduty_findings_kms_key_arn
}

# All region specific modules
module "guardduty_baseline_ap-northeast-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.ap-northeast-1a
    aws.dst = aws.ap-northeast-1b
  }

  enabled                         = contains(var.target_regions, "ap-northeast-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_ap-northeast-2" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.ap-northeast-2a
    aws.dst = aws.ap-northeast-2b
  }

  enabled                         = contains(var.target_regions, "ap-northeast-2")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_ap-south-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.ap-south-1a
    aws.dst = aws.ap-south-1b
  }

  enabled                         = contains(var.target_regions, "ap-south-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_ap-southeast-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.ap-southeast-1a
    aws.dst = aws.ap-southeast-1b
  }

  enabled                         = contains(var.target_regions, "ap-southeast-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_ap-southeast-2" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.ap-southeast-2a
    aws.dst = aws.ap-southeast-2b
  }

  enabled                         = contains(var.target_regions, "ap-southeast-2")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_ca-central-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.ca-central-1a
    aws.dst = aws.ca-central-1b
  }

  enabled                         = contains(var.target_regions, "ca-central-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_eu-central-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.eu-central-1a
    aws.dst = aws.eu-central-1b
  }

  enabled                         = contains(var.target_regions, "eu-central-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_eu-north-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.eu-north-1a
    aws.dst = aws.eu-north-1b
  }

  enabled                         = contains(var.target_regions, "eu-north-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_eu-west-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.eu-west-1a
    aws.dst = aws.eu-west-1b
  }

  enabled                         = contains(var.target_regions, "eu-west-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_eu-west-2" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.eu-west-2a
    aws.dst = aws.eu-west-2b
  }

  enabled                         = contains(var.target_regions, "eu-west-2")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_eu-west-3" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.eu-west-3a
    aws.dst = aws.eu-west-3b
  }

  enabled                         = contains(var.target_regions, "eu-west-3")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_sa-east-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.sa-east-1a
    aws.dst = aws.sa-east-1b
  }

  enabled                         = contains(var.target_regions, "sa-east-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_us-east-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.us-east-1a
    aws.dst = aws.us-east-1b
  }

  enabled                         = contains(var.target_regions, "us-east-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_us-east-2" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.us-east-2a
    aws.dst = aws.us-east-2b
  }

  enabled                         = contains(var.target_regions, "us-east-2")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_us-west-1" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.us-west-1a
    aws.dst = aws.us-west-1b
  }

  enabled                         = contains(var.target_regions, "us-west-1")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

module "guardduty_baseline_us-west-2" {
  source = "./modules/guardduty-baseline"

  providers = {
    aws.src = aws.us-west-2a
    aws.dst = aws.us-west-2b
  }

  enabled                         = contains(var.target_regions, "us-west-2")
  gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
  gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
  gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
  gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
  gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

  tags = var.tags
}

# module "guardduty_baseline_af-south-1" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.af-south-1a
#     aws.dst = aws.af-south-1b
#   }

#   enabled                         = contains(var.target_regions, "af-south-1")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }

# module "guardduty_baseline_ap-east-1" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.ap-east-1a
#     aws.dst = aws.ap-east-1b
#   }

#   enabled                         = contains(var.target_regions, "ap-east-1")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }

# module "guardduty_baseline_cn-north-1" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.cn-north-1a
#     aws.dst = aws.cn-north-1b
#   }

#   enabled                         = contains(var.target_regions, "cn-north-1")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }

# module "guardduty_baseline_cn-northwest-1" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.cn-northwest-1a
#     aws.dst = aws.cn-northwest-1b
#   }

#   enabled                         = contains(var.target_regions, "cn-northwest-1")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }

# module "guardduty_baseline_eu-south-1" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.eu-south-1a
#     aws.dst = aws.eu-south-1b
#   }

#   enabled                         = contains(var.target_regions, "eu-south-1")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }

# module "guardduty_baseline_me-south-1" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.me-south-1a
#     aws.dst = aws.me-south-1b
#   }

#   enabled                         = contains(var.target_regions, "me-south-1")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }

# module "guardduty_baseline_ap-northeast-3" {
#   source = "./modules/guardduty-baseline"

#   providers = {
#     aws.src = aws.ap-northeast-3a
#     aws.dst = aws.ap-northeast-3b
#   }

#   enabled                         = contains(var.target_regions, "ap-northeast-3")
#   gd_finding_publishing_frequency = local.guardduty_finding_publishing_frequency
#   gd_delegated_admin_acc_id       = local.guardduty_admin_account_id
#   gd_my_org                       = data.terraform_remote_state.guardduty_org.outputs.my_org
#   gd_publishing_dest_bucket_arn   = local.guardduty_findings_bucket_arn
#   gd_kms_key_arn                  = local.guardduty_findings_kms_key_arn

#   tags = var.tags
# }
