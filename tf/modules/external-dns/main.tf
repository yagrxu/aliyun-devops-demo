
provider "kubernetes" {
  config_path            = "~/.kube/config-demo"
}



resource "kubernetes_deployment" "alicloud_external_dns" {
  metadata {
    name = "external-dns"
    annotations = {
      "ram.aliyuncs.com/role" = var.dns_ram_role
    }
  }

  spec {
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "external-dns"
      }
    }

    template {
      metadata {
        labels = {
          app = "external-dns"
        }
      }

      spec {
        container {
          image = "registry.opensource.zalan.do/teapot/external-dns:latest"
          name  = "external-dns"
          args = [
            "--source=service",
            "--source=ingress",
            "--domain-filter=${var.domain_name} # will make ExternalDNS see only the hosted zones matching provided domain, omit to process all available hosted zones",
            "--provider=alibabacloud",
            //"--policy=upsert-only # would prevent ExternalDNS from deleting any records, omit to enable full synchronization",
            "--alibaba-cloud-zone-type=public",
            "--registry=txt",
            "--txt-owner-id=my-identifier",
          ]
          volume_mount {
            name       = "hostpath"
            mount_path = "/usr/share/zoneinfo"
          }
        }
        volume {
          name = "hostpath"
          host_path {
            type = "Directory"
            path = "/usr/share/zoneinfo"
          }
        }
      }
    }
  }
}

