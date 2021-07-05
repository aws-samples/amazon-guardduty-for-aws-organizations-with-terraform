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

terraform {
  backend "s3" {
    bucket = "gd-tfm-remote-backend-1"
    key    = "gd.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "s3-state-lock"
  }
}


data "terraform_remote_state" "guardduty_org" {
  backend = "s3"

  config = {
    bucket = "gd-tfm-remote-backend-1"
    key    = "remoteorg.tfstate"
    region = "ap-southeast-1"
  }
}

data "terraform_remote_state" "guardduty_findings_store" {
  backend = "s3"

  config = {
    bucket = "gd-tfm-remote-backend-1"
    key    = "gd-findings-store.tfstate"
    region = "ap-southeast-1"
  }
}
