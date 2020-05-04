cd ./tf/dev
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve