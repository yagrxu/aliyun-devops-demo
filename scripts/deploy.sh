# uaa_setup
mkdir ~/.kube/
cd ./tf/uaa_setup
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "Error applying plan" )

# dev
cd ../dev
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "Error applying plan" )

# dev
terraform destroy --auto-approve

cd ../uaa_setup
# uaa_setup
terraform destroy --auto-approve
