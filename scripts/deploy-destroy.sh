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
export TF_VAR_cluster_id=`tf output cluster_id`
cd ../../scripts
python3 ./update_config.py

# destroy k8s_services-native
cd ../tf/k8s_services_native
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# destroy k8s_services
cd ../tf/k8s_services
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# k8s_services
terraform destroy --auto-approve

# k8s_services_native
cd ../k8s_services_native
terraform destroy --auto-approve

# dev
cd ../dev
terraform destroy --auto-approve

# account_setup
cd ../account_setup
terraform destroy --auto-approve

# verify result
cd ../../scripts
sh ./validation.sh