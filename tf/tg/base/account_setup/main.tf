provider "alicloud" {
  version    = "~>1.94.0"
  region     = var.region
}

terraform {
  backend "oss" {
  }
}

module "ram" {
  source            = "../../../../../../../../modules/ram/"
  account_id        = "5326847730248958"
}
