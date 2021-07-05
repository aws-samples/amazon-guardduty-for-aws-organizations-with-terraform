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
# Outputs from guardduty-baseline module.
# --------------------------------------------------------------------------------------------------

output "guardduty_detector" {
  description = "The GuardDuty detector in each region."

  value = {
    "ap-northeast-1" = module.guardduty_baseline_ap-northeast-1.guardduty_detector
    "ap-northeast-2" = module.guardduty_baseline_ap-northeast-2.guardduty_detector
    "ap-south-1"     = module.guardduty_baseline_ap-south-1.guardduty_detector
    "ap-southeast-1" = module.guardduty_baseline_ap-southeast-1.guardduty_detector
    "ap-southeast-2" = module.guardduty_baseline_ap-southeast-2.guardduty_detector
    "ca-central-1"   = module.guardduty_baseline_ca-central-1.guardduty_detector
    "eu-central-1"   = module.guardduty_baseline_eu-central-1.guardduty_detector
    "eu-north-1"     = module.guardduty_baseline_eu-north-1.guardduty_detector
    "eu-west-1"      = module.guardduty_baseline_eu-west-1.guardduty_detector
    "eu-west-2"      = module.guardduty_baseline_eu-west-2.guardduty_detector
    "sa-east-1"      = module.guardduty_baseline_sa-east-1.guardduty_detector
    "us-east-1"      = module.guardduty_baseline_us-east-1.guardduty_detector
    "us-east-2"      = module.guardduty_baseline_us-east-2.guardduty_detector
    "us-west-1"      = module.guardduty_baseline_us-west-1.guardduty_detector
    "us-west-2"      = module.guardduty_baseline_us-west-2.guardduty_detector
  }
}

