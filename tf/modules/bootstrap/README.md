# bootstrap module

## Overview

This Terraform module prepares a new Alibaba Cloud account so that it can be used with Terraform.

The module will do the following in any given account:

- create an OSS bucket to store Terraform's state remotely
- create an OTS instance and table for Terraform state locking
- create a RAM user and role to allow Terraform to provision the account (via assume role)
- output a ready-to-use Terragrunt config based on the created resources

You only need to apply this module once per Alibaba account using vanilla Terraform. (You cannot use Terragrunt for this, as it requires a state bucket to already exist in order to work. On AWS, Terragrunt will automatically create that bucket for us, but that's not supported for Alibaba, unfortunately.)

## Example

To bootstrap a new account called "example", create this Terraform file:

```terraform
# environments/alicloud/example/bootstrap/main.tf
module "bootstrap" {
  source            = "path/to/modules/alicloud/bootstrap"
  account_id        = "0123456789012345"
  master_account_id = "9876543210987654"
}

output "terragrunt_config" {
  value = module.bootstrap.terragrunt_config
}
```

Then apply the module via the Terraform CLI:

```
cd environments/alicloud/example/bootstrap
terraform init
terraform apply
```

Next, create a Terragrunt config file from the Terraform output, for example:

```hcl
# environments/alicloud/example/terragrunt.hcl
remote_state {
  backend = "oss"
  config = {
    bucket              = "0123456789012345-terraform-state"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    region              = "eu-central-1"
    tablestore_endpoint = "https://tf-012345678901.eu-central-1.ots.aliyuncs.com"
    tablestore_table    = "statelock"
  }
}
```

With this config in hand, you are ready to use Terragrunt for provisioning resources in the given Alibaba Cloud account.
