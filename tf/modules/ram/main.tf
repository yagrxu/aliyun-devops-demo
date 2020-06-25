module technical_role {
  source          = "../ram_role"
  role_name       = "TechnicalRole"
  description     = "technical role for automation"
  policy_name     = "AdministratorAccess"
  policy_type     = "System"
  document_policy = <<EOF
    {
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "RAM": ["acs:ram::${var.account_id}:user/test"]
          }
        }
      ],
      "Version": "1"
    }
    EOF
}

resource "alicloud_ram_policy" "policy" {
  name        = "AssumeTechnicalRole"
  description = "allow RAM user test to assume technical role"
  document    = <<EOF
    {
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Resource": ["acs:ram::*:role/TechnicalRole"]
        }
      ],
      "Version": "1"
    }
    EOF
}

resource "alicloud_ram_user_policy_attachment" "ram_policy_attachment" {
  policy_name = alicloud_ram_policy.policy.name
  policy_type = alicloud_ram_policy.policy.type
  user_name   = "test"
}

resource "alicloud_ram_policy" "dns_policy" {
  name        = "DnsPolicy"
  description = "allow external DNS to access domain service"
  document    = <<EOF
    {
      "Version": "1",
      "Statement": [
        {
          "Action": "alidns:AddDomainRecord",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "alidns:DeleteDomainRecord",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "alidns:UpdateDomainRecord",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "alidns:DescribeDomainRecords",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "alidns:DescribeDomains",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "pvtz:AddZoneRecord",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "pvtz:DeleteZoneRecord",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "pvtz:UpdateZoneRecord",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "pvtz:DescribeZoneRecords",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "pvtz:DescribeZones",
          "Resource": "*",
          "Effect": "Allow"
        },
        {
          "Action": "pvtz:DescribeZoneInfo",
          "Resource": "*",
          "Effect": "Allow"
        }
      ]
    }
      EOF
}
module dns_role {
  source          = "../ram_role"
  role_name       = "DnsRole"
  description     = "role for external DNS"
  policy_name     = alicloud_ram_policy.dns_policy.name
  policy_type     = "Custom"
  document_policy = <<EOF
    {
      "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "cs.aliyuncs.com"
                ]
            }
        },
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "RAM": [
                    "acs:ram::${var.account_id}:root"
                ]
            }
        }
      ],
      "Version": "1"
    }
    EOF
}

resource "alicloud_ram_policy" "kube2ram_sts_policy" {
  name        = "Kube2RamStsPolicy"
  description = "allow kube2ram assume correct role"
  document    = <<EOF
    {
      "Version": "1",
      "Statement": [
        {
            "Action": [
              "sts:AssumeRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
      ]
    }
    EOF
}

resource "alicloud_ram_policy" "external_secret_policy" {
  name        = "ExternalSecretPolicy"
  description = "allow external DNS to access domain service"
  document    = <<EOF
    {
      "Version": "1",
      "Statement": [
        {
          "Action": [
              "kms:GetSecretValue"
          ],
          "Resource": [
              "*"
          ],
          "Effect": "Allow"
        }
      ]
    }
    EOF
}

resource "alicloud_ram_policy" "autoscaler_policy" {
  name                   = "k8s_autoscaler_policy"
  description            = "enable scaling"
  document               = <<EOF
  {
    "Version": "1",
    "Statement": [
        {
          "Action": [
              "ess:Describe*", 
              "ess:CreateScalingRule", 
              "ess:ModifyScalingGroup", 
              "ess:RemoveInstances", 
              "ess:ExecuteScalingRule", 
              "ess:ModifyScalingRule", 
              "ess:DeleteScalingRule", 
              "ecs:DescribeInstanceTypes",
              "ess:DetachInstances"
          ],
          "Resource": [
              "*"
          ],
          "Effect": "Allow"
        }
      ]
  }
  EOF
}