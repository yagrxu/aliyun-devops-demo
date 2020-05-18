# account_setup
cd ./tf/account_setup
terraform init
terraform validate
terraform plan
terraform apply --auto-approve

# dev
cd ../dev
terraform init
terraform validate
terraform plan

# k8s_services
cd ../kubernetes_services
terraform init
terraform validate

cd ../account_setup
# account_setup
terraform destroy --auto-approve
