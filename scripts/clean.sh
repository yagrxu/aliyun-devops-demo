# uaa_setup
cd ./tf/account_setup
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve

# destroy k8s_services
cd ../k8s_services
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve

# destroy dev
cd ../dev
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve | tee /dev/tty | ( ! grep "Error:" )

# destroy account_setup
cd ../account_setup
terraform init
terraform validate
terraform plan
terraform destroy --auto-approve | tee /dev/tty | ( ! grep "Error:" )