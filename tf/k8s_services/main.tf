provider "kubernetes" {
  config_path = "~/.kube/config-demo"
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-k8s-services"
    region   = "eu-central-1"
  }
}

module "kube2ram" {
  source         = "../modules/kube2ram"
  host_interface = "cali+"
}

module "external-dns" {
  source         = "../modules/external-dns"
  dns_ram_role   = "DnsRole"
  domain_name    = "yagr.xyz"
}