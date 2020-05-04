# destroy dev
cd ../dev
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve

# destroy bootstrap
cd ./tf/bootstrap
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve