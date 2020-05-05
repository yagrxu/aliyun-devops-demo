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
