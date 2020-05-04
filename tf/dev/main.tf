provider "alicloud" {
  version    = "~> 1.81.0"
  access_key = var.access_key
  secret_key = var.access_secret
  region     = var.region
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo"
    region   = "eu-central-1"
  }
}

module vpc {
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
