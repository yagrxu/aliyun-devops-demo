
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
  # bug
  set {
    name  = "controller.operatorImage"
    value = "registry-vpc.${var.region_id}.aliyuncs.com/arms-docker-repo/arms-prom-operator:v0.1"
  }

  set {
    name  = "controller.nodeExportorImage"
    value = "registry-vpc.${var.region_id}.aliyuncs.com/acs/node-exporter:v0.17.0"
  }

  set {
    name  = "controller.armsRBACProxyImage"
    value = "registry-vpc.${var.region_id}.aliyuncs.com/arms-docker-repo/arms-kube-rbac-proxy:v0.4.1"
  }

  set {
    name  = "controller.kubeStateMetric"
    value = "registry-vpc.${var.region_id}.aliyuncs.com/acs/kube-state-metrics:v1.6.0"
  }

  set {
    name  = "controller.gpuExportorImage"
    value = "registry-vpc.${var.region_id}.aliyuncs.com/acs/gpu-prometheus-exporter:0.1-31fa45b"
  }

  depends_on = [kubernetes_namespace.arms_prom]
}