# destroy dev
cd ./tf/dev
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve

# destroy uaa_setup
cd ../uaa_setup
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve