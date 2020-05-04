# bootstrap
cd ./tf/bootstrap
terraform init
terraform validate
terraform plan
terraform apply --auto-approve

# dev
cd ../dev
terraform init
terraform validate
terraform plan
terraform apply --auto-approve

# destroy
terraform destroy --auto-approve

# dev
terraform destroy --auto-approve
