provider "alicloud" {
  version    = "~> 1.81.0"
  region     = var.region
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-bootstrap"
    region   = "eu-central-1"
  }
}
module "bootstrap" {
  source            = "../modules/bootstrap"
  account_id        = "5326847730248958"
}