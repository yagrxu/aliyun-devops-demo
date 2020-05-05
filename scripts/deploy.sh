# uaa_setup
cd ./tf/uaa_setup
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

# dev
terraform destroy --auto-approve

cd ../uaa_setup
# uaa_setup
terraform destroy --auto-approve
