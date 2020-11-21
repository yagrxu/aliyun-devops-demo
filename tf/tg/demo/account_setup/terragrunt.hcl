include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//base/account_setup"
}

inputs = {
    account_id        = "5326847730248958"
}
