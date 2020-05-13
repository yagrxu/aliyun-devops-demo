provider "alicloud" {
  version    = "~> 1.82.0"
  region     = var.region
  assume_role {
    role_arn = "acs:ram::5326847730248958:role/TechnicalRole"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config-demo"
}

provider "helm" {
  version    = "~> 1.1.1"
  kubernetes {
    config_path = "~/.kube/config-demo"
  }
}

data "alicloud_account" "current" {
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-k8s-services-native"
    region   = "eu-central-1"
  }
}

module "kube2ram" {
  source         = "../modules/kube2ram"
  host_interface = "cali+"
}

module managed_prometheus {
  source             = "../modules/arms"
  uid                = data.alicloud_account.current.id
  region_id          = var.region
  cluster_id         = var.cluster_id
}
