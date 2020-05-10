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

# k8s_services
cd ../k8s_services
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )