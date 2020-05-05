# Aliyun DevOps Automation Demo

[![Build Status](https://travis-ci.com/yagrxu/aliyun-devops-demo.svg?token=ky8D33r1sooBTDsLx6aG&branch=master)](https://travis-ci.com/yagrxu/aliyun-devops-demo)

## Prerequisites (Manual Steps)

1. You have already a valid, ready to use Alibaba Cloud or Aliyun account.
2. You have activated the following services (if activation is required)
    - ECS (Elastic Compute Service)
    - Auto Scaling
    - ARMS (Application Real-time Monitoring Service)
    - Log Service
    - Domain Service
    - ACK (Managed Kubernetes)
    - ACR (Managed Container Registry)

3. You need to prepare a valid OSS Bucket for storing the terraform state optionally with a OTS table for locking ( One can achieve this by using terraform or aliyun cli but it is not in our demo scope)

4. You need to prepare a RAM user with proper permission

## Workflow

The work flow is already described programmatically in the testing code.

## Pipeline

The pipeline is integrated with travis ci kostenlose edition

## terraform modules

The terraform modules are centrally maintained in another public repo
