provider "alicloud" {
  version    = "~> 1.81.0"
  region     = var.region
  assume_role {
    role_arn = "acs:ram::5326847730248958:role/TerraformRole"
  }
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-dev"
    region   = "eu-central-1"
  }
}

module dev_vpc {
  source             = "../modules/vpc"
  vpc_cidr           = "10.0.0.0/8"
  pod_subnets        = ["10.0.64.0/24", "10.1.0.0/16"]
  private_subnets    = ["10.2.0.0/24", "10.2.1.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  environment        = "dev"
  product            = "product1"
  // not used
  region             = "eu-central-1"
}

module dev_admin_role {
  source             = "../modules/ram_role"
  role_name          = "AAD"
  description        = "Role for STS"
  policy_name        = "AdministratorAccess"
  document_policy    = <<EOF
    {
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "RAM": [
                        "acs:ram::5326847730248958:user/test"
                    ]
                }
            }
        ],
        "Version": "1"
    }
    EOF
}