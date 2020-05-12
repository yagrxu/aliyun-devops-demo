# uaa_setup
mkdir ~/.kube/
cd ./tf/account_setup
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# dev
cd ../dev
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# update config
python3 ./update_config.py

# destroy k8s_services
cd ./tf/k8s_services
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# k8s_services
terraform destroy --auto-approve

# dev
cd ../dev
terraform destroy --auto-approve

# account_setup
cd ../account_setup
terraform destroy --auto-approve

# verify result
sh ./validation.sh