# destroy dev
cd ./tf/dev
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve

# destroy account_setup
cd ../account_setup
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve