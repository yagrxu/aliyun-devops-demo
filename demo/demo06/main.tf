provider "alicloud" {
  version    = "~> 1.88.0"
  region     = var.region
}

terraform {
  backend "oss" {
    bucket   = "yagr-intl-tf-state"
    prefix   = "aliyun-devops-demo06"
    region   = "eu-central-1"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config-demo"
}

resource "alicloud_slb" "slb" {
  name          = var.name
  specification = var.spec
  vswitch_id    = "vsw-gw8w2ploqlbl2c28xu3yk"
  address_type  = var.address_type
  instance_charge_type = var.instance_charge_type
}

resource "alicloud_eip" "slb_eip" {
  name  = "slb-eip"
}

resource "alicloud_eip_association" "slb-eip-asso" {
  allocation_id = alicloud_eip.slb_eip.id
  instance_id   = alicloud_slb.slb.id
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "demo06"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "demo06"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo06"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"
          port {
              container_port = 80
              name = "http"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test_service" {
  metadata {
    name = "demo06"
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "demo06-service.yagr.xyz"
      "service.beta.kubernetes.io/alibaba-cloud-loadbalancer-id" = alicloud_slb.slb.id
      "service.beta.kubernetes.io/alibaba-cloud-loadbalancer-force-override-listeners" = "true"
    }
  }
  spec {
    selector = {
      app = "demo06"
    }
    external_traffic_policy = "Local"
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
      name        = "http"
    }

    type = "LoadBalancer"
  }
}