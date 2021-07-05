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
# A list of providers for all AWS regions.
# Reference: https://docs.aws.amazon.com/general/latest/gr/rande.html
# --------------------------------------------------------------------------------------------------


provider "aws" {
  region = var.target_regions[0]
}

provider "aws" {
  region = var.target_regions[0]
  alias  = "default-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.logging_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ap-northeast-1a"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "ap-northeast-1b"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ap-northeast-2a"
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "ap-northeast-2b"
  region = "ap-northeast-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ap-northeast-3a"
  region = "ap-northeast-3"
}

provider "aws" {
  alias  = "ap-northeast-3b"
  region = "ap-northeast-3"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ap-south-1a"
  region = "ap-south-1"
}
provider "aws" {
  alias  = "ap-south-1b"
  region = "ap-south-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ap-southeast-1a"
  region = "ap-southeast-1"
}
provider "aws" {
  alias  = "ap-southeast-1b"
  region = "ap-southeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ap-southeast-2a"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "ap-southeast-2b"
  region = "ap-southeast-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "ca-central-1a"
  region = "ca-central-1"
}

provider "aws" {
  alias  = "ca-central-1b"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "eu-central-1a"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "eu-central-1b"
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "eu-north-1a"
  region = "eu-north-1"
}

provider "aws" {
  alias  = "eu-north-1b"
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "eu-west-1a"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "eu-west-1b"
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "eu-west-2a"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "eu-west-2b"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "eu-west-3a"
  region = "eu-west-3"
}

provider "aws" {
  alias  = "eu-west-3b"
  region = "eu-west-3"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "sa-east-1a"
  region = "sa-east-1"
}

provider "aws" {
  alias  = "sa-east-1b"
  region = "sa-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "us-east-1a"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-1b"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "us-east-2a"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-east-2b"
  region = "us-east-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "us-west-1a"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-1b"
  region = "us-west-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

provider "aws" {
  alias  = "us-west-2a"
  region = "us-west-2"
}

provider "aws" {
  alias  = "us-west-2b"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
  }
}

# provider "aws" {
#   alias  = "af-south-1a"
#   region = "af-south-1"
# }

# provider "aws" {
#   alias  = "af-south-1b"
#   region = "af-south-1"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }

# provider "aws" {
#   alias  = "ap-east-1a"
#   region = "ap-east-1"
# }

# provider "aws" {
#   alias  = "ap-east-1b"
#   region = "ap-east-1"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }

# provider "aws" {
#   alias  = "cn-north-1a"
#   region = "cn-north-1"
# }

# provider "aws" {
#   alias  = "cn-north-1b"
#   region = "cn-north-1"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }

# provider "aws" {
#   alias  = "cn-northwest-1a"
#   region = "cn-northwest-1"
# }

# provider "aws" {
#   alias  = "cn-northwest-1b"
#   region = "cn-northwest-1"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }

# provider "aws" {
#   alias  = "eu-south-1a"
#   region = "eu-south-1"
# }

# provider "aws" {
#   alias  = "eu-south-1b"
#   region = "eu-south-1"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }

# provider "aws" {
#   alias  = "me-south-1a"
#   region = "me-south-1"
# }

# provider "aws" {
#   alias  = "me-south-1b"
#   region = "me-south-1"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }

# provider "aws" {
#   alias  = "ap-northeast-3a"
#   region = "ap-northeast-3"
# }

# provider "aws" {
#   alias  = "ap-northeast-3b"
#   region = "ap-northeast-3"
#   assume_role {
#     role_arn = "arn:aws:iam::${var.delegated_admin_acc_id}:role/${var.assume_role_name}"
#   }
# }