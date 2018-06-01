#!/bin/sh

# Setting up docker hub login credentials
DOCKERHUB_USERNAME=
DOCKERHUB_PASSWORD=

# Exporting Terraform required environment variables
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

echo "Obtaining ECS optimized AMI image..."
TF_VAR_ecs_ami_image_id="$(aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux/recommended/image_id --region ${TF_VAR_region} --query "Parameters[0].Value")"
export TF_VAR_ecs_ami_image_id

echo "AMI image: $TF_VAR_ecs_ami_image_id"

# Building Nginx image based in Ubuntu 16.04 image
echo "Building nginx docker image..."
docker build -t nginxhello .

# Tag Nginx image
docker tag nginxhello ${DOCKERHUB_USERNAME}/nginxhello:latest

# Login to Docker Hub
docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}

# Push Nginx image to Docker Hub
echo "Pushing nginx docker image to Docker Hub..."
docker push ${DOCKERHUB_USERNAME}/nginxhello:latest

cd terraform/

# Run Terrafrom init
terraform init 

# Run Terrafrom plan
terraform plan 

# Run Terrafrom to apply ECS configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve 

echo "Performing HTTP health check of ECS cluster..."
for i in {1..30}
    do
        sleep 5
        echo "Health check of ECS cluster. Try "${i}" of 30..." 
        curl -Is http://$(terraform output ecs-load-balancer-dns-name) | head -1
    done