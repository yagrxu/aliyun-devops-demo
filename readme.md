# Aliyun DevOps Automation Demo

[![Build Status](https://travis-ci.com/yagrxu/aliyun-devops-demo.svg?token=ky8D33r1sooBTDsLx6aG&branch=master)](https://travis-ci.com/yagrxu/aliyun-devops-demo)

## Which is not in scope of the demo

1. AD integration or any IdP integration is not part of the demo.

    - This involves many manual configuration steps and external tools which cannot be automated properly in a independent github repo
    - The outcome of the integration could be RAM(Resource Access Management) users or RAM roles that will be used for automating the cloud DevOps. You can consider this repo demo as the next step of the IdP/AD integration

2. #TODO

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
3. To be able to automate the complete story, you need to prepare a domain name in advance.

4. You need to prepare a valid OSS Bucket for storing the terraform state optionally with a OTS table for locking ( One can achieve this by using terraform or aliyun cli but it is not in our demo scope)
5. You need to prepare a valid RAM role in your account or in each of hierachical resource      management accounts. In the demo, I use terraform code to simulate a RAM role creation during the account setup step.

6. You need to prepare a RAM user with proper permission

## Workflow

1. Accounts Setup

    In this step, you have an empty account and you need to prepare the content below (Account Setup modules)

    - UAA (User Authentication and Authorization)
    - RAM roles for Service to Service authentication #TODO
    - RAM roles for ECS/pod assumption

2. Managed Services Setup

    - K8s and his friends (VPC, VSwitch, Security Group, Log Service)
    - Database (schema, accounts, whitelists)
    - KMS
    - ...

3. Solution Services Setup

    - Kube2Ram
    - Ingress
    - Monitoring
    - Logging
    - External-dns
    - External-secrets

## Conceptual Design

