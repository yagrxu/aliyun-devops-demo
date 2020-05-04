resource "alicloud_ram_role" "terraform" {
  name        = "TerraformRole"
  description = "Grant admin access to test RAM user"
  force       = true
  document    = <<EOF
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

resource "alicloud_ram_policy" "assume_role" {
  name        = "TerraformAssumeRoleAccess"
  description = "Allow Terraform user to assume its role"
  force       = true
  document    = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Resource": ["acs:ram::*:role/TerraformRole"]
    }
  ],
  "Version": "1"
}
EOF
}

resource "alicloud_ram_user_policy_attachment" "assume_role" {
  policy_name = alicloud_ram_policy.assume_role.name
  policy_type = alicloud_ram_policy.assume_role.type
  user_name   = "test"
}

resource "alicloud_ram_role_policy_attachment" "role_attach_policy" {
  policy_name = "AdministratorAccess"
  policy_type = "System"
  role_name   = alicloud_ram_role.terraform.name
}