provider "alicloud" {
  version    = "~> 1.94.0"
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
    prefix   = "aliyun-devops-demo/kubernetes-services"
    region   = "eu-central-1"
  }
}

module "kubernetes_services" {
  source         = "../modules/services"
  host_interface = "cali+"
  dns_ram_role   = "acs:ram::${data.alicloud_account.current.id}:role/dnsrole"
  domain_name    = "yagr.xyz"
  account_id     = data.alicloud_account.current.id
}

module arms {
  source             = "../modules/arms"
  uid                = data.alicloud_account.current.id
  region_id          = var.region
  cluster_id         = var.cluster_id
}

module secret-manager {
  source             = "../modules/secret"
  region             = var.region
}

module cert-manager {
  source             = "../modules/cert"
}