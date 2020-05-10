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
len=$(aliyun vpc DescribeVpcs --RegionId eu-central-1 | jq '.Vpcs.Vpc | length')
if [ $len != 0 ]
then
    >&2 echo 'VPC not removed'
    exit 1
else
    echo 'VPC resource cleaned up'
fi