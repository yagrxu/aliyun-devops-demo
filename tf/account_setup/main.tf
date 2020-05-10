provider "alicloud" {
  version    = "~> 1.81.0"
  region     = var.region
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-account-setup"
    region   = "eu-central-1"
  }
}

module "ram" {
  source            = "../modules/ram"
  account_id        = "5326847730248958"
}
