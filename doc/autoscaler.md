# Kubernetes Autoscaler for Alibaba Cloud

## What is Kubernetes Autoscaler

To begin with, you need to have a basic understanding from [The official repo](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler).

## Functionalities

!! - copied from the official repo - !!

[Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) - a component that automatically adjusts the size of a Kubernetes
Cluster so that all pods have a place to run and there are no unneeded nodes. Works with GCP, AWS and Azure. Version 1.0 (GA) was released with kubernetes 1.8.

[Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler) - a set of components that automatically adjust the
amount of CPU and memory requested by pods running in the Kubernetes Cluster. Current state - beta.

[Addon Resizer](https://github.com/kubernetes/autoscaler/tree/master/addon-resizer) - a simplified version of vertical pod autoscaler that modifies
resource requests of a deployment based on the number of nodes in the Kubernetes Cluster. Current state - beta.

Since Vertical Pod Autoscaler and Addon Resizer are still in beta, we will focus on Cluster Autoscaler in this document.

## How it works

Most of the scenarios are mentioned here: [FAQ](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md)

I will only highlight on the matrix below to answer the question: When it will scale up and when it will scale down?

| Request | Utilization | usage | total | Scale Up | Scale Down | Comments |
|---|---|---|---|---|---|---|
| + 2000m CPU | 50% | 30% | 4000m | No | No | 2800m(still available) > 2000m(request) |
| + 100m CPU | 50% | 80% | 4000m | No | No | 800m(still available) > 100m(request) |
| + 3000m CPU | 50% | 30% | 4000m | Yes | No | 2800m(still available) < 3000m(request) |
| - 1000m CPU | 50% | 60% | 4000m | No | Yes | 35%(new usage) < 50%(Utilization Value) |
| +3 pod | N/A | 20 | 22 | Yes | No | 23 pods > 22 total pod limit |
| -5 pod | 50% | 25 | 27 | No | Possible | If 1 less node can still handle the resource requests |

## Working with Alibaba Cloud Managed Kubernetes Cluster

Supported Authentications:

1. AccessKey and SecretKey

2. STS using Kubernetes worker role

3. STS using [Kube2Ram](https://github.com/AliyunContainerService/kube2ram)

Supported IaC:

1. terraform

2. helmchart
