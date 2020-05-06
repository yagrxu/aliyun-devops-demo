# Aliyun DevOps Automation Demo

[![Build Status](https://travis-ci.com/yagrxu/aliyun-devops-demo.svg?token=ky8D33r1sooBTDsLx6aG&branch=master)](https://travis-ci.com/yagrxu/aliyun-devops-demo)

## Prerequisites (Manual Steps)

1. You have already a valid, ready to use Alibaba Cloud or Aliyun account.
2. You have activated the following services (if activation is required)
    - ECS (Elastic Compute Service)
    - Auto Scaling
    - ARMS (Application Real-time Monitoring Service)
    - KMS (Key Management Service)
    - Log Service
    - Domain Service
    - ACK (Managed Kubernetes)
    - ACR (Managed Container Registry)

3. You need to prepare a valid OSS Bucket for storing the terraform state optionally with a OTS table for locking ( One can achieve this by using terraform or aliyun cli but it is not in our demo scope)
4. You need to prepare a valid RAM role in your account or in each of hierachical resource management accounts. In the demo, I use terraform code to simulate a RAM role creation during the account setup step.

5. You need to prepare a RAM user with proper permission

## Workflow

1. Accounts Setup

In this step, I only prepared a ram role which can be used for terraform automation in the dev setup. However account setup means much more than just RAM (Resource Access Management)
2. Managed Services Setup
3. Solution Services Setup

## Pipeline

The pipeline is integrated with travis ci kostenlose edition

## terraform modules

The terraform modules are centrally maintained in another public repo
