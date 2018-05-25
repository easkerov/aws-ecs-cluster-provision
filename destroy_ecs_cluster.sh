# Exporting Terraform environment variables
export TF_VAR_aws_access_key_id=
export TF_VAR_aws_secret_access_key=
export TF_VAR_ecs_cluster="nginx-ecs-demo-cluster"
export TF_VAR_region="us-west-1"
export TF_VAR_test_vpc="vpc_ecs_demo"
export TF_VAR_test_network_cidr="192.168.0.0/16"
export TF_VAR_test_public_01_cidr="192.168.1.0/24"
export TF_VAR_test_public_02_cidr="192.168.2.0/24"
export TF_VAR_max_instance_size="2"
export TF_VAR_min_instance_size="2"
export TF_VAR_desired_capacity="2"

TF_VAR_ecs_ami_image_id="$(aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id --region ${TF_VAR_region} --query "Parameters[0].Value")"
export TF_VAR_ecs_ami_image_id

cd terraform/

# Run Terrafrom to destroy ECS configuration
echo "Destroying ECS Cluster..."
terraform destroy -auto-approve 