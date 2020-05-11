
resource "kubernetes_namespace" "arms_prom" {
  metadata {
    annotations = {
      name = "arms-prom"
    }
    name = "arms-prom"
  }
}

resource "helm_release" "arms" {
  name       = "managed-prom"
  repository = "http://aliacs-k8s-eu-central-1.oss-eu-central-1.aliyuncs.com/app/charts-incubator/"
  chart      = "ack-arms-prometheus"
  namespace  = "arms-prom"

  set {
    name  = "controller.cluster_id"
    value = var.cluster_id
  }

  set {
    name  = "controller.uid"
    value = var.uid
  }

  set {
    name  = "controller.region_id"
    value = var.region_id
  }

  depends_on = [kubernetes_namespace.arms_prom]
}