# account_setup
mkdir ~/.kube/
cd ./tf/account_setup
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# cloud_services
cd ../cloud_services
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )

# export env values
export TF_VAR_cluster_id=`terraform output cluster_id`
export TF_VAR_connection_string=`terraform output connection_string`

# update config
cd ../../scripts
python3 ./update_config.py

# create secret for ACR
kubectl create secret docker-registry regcred --docker-server=registry-intl.eu-central-1.aliyuncs.com --docker-username=$ALICLOUD_ACR_USER --docker-password=$ALICLOUD_ACR_PASSWORD --docker-email=$ALICLOUD_ACR_USER

# deploy log CRD
kubectl apply -f ../tf/modules/services/logging-crd.yaml

# update ingress controller configuration
kubectl patch service nginx-ingress-lb -p '{"spec":{"externalTrafficPolicy":"Cluster"}}' -n kube-system

# k8s_services
cd ../tf/kubernetes_services
terraform init
terraform validate
terraform plan -detailed-exitcode
terraform apply --auto-approve | tee /dev/tty | ( ! grep "[ERROR]" )