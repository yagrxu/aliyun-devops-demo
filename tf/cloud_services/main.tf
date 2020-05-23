provider "alicloud" {
  version    = "~> 1.81.0"
  region     = var.region
  assume_role {
    role_arn = "acs:ram::5326847730248958:role/TechnicalRole"
  }
}
provider "helm" {
  version    = "~> 1.1.1"
  kubernetes {
    config_path = "~/.kube/config-demo"
  }
}
terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo-dev"
    region   = "eu-central-1"
  }
}
data "alicloud_account" "current" {
}
module dev_vpc {
  source             = "../modules/vpc"
  vpc_cidr           = "10.0.0.0/8"
  pod_subnets        = ["10.0.64.0/24", "10.1.0.0/16"]
  worker_subnets     = ["10.2.0.0/24", "10.2.1.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  env                = "dev"
  product            = "demo"
}

module managed_k8s {
  source             = "../modules/ack"
  pod_vswitch_ids    = module.dev_vpc.pod_vswitch_ids
  worker_vswitch_ids = module.dev_vpc.worker_vswitch_ids
  worker_types       = ["ecs.g6.xlarge"]
  account_id         = data.alicloud_account.current.id
}

module database {
  source             = "../modules/rds"
  vswitch_id         = module.dev_vpc.worker_vswitch_ids[0]
  security_ips       = ["10.0.0.0/8"]
  version_ids        = ["2020.05.05", "2020.05.05", "2020.05.05"]
}
