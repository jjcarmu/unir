#!/bin/bash
AMI_ID=$(aws ec2 describe-images --owners self --query Images[].ImageId --output text)
#echo $AMI_ID
AWS_REGION="$1"
#echo $AWS_REGION
EC2_INSTANCE_TYPE="$2"
#echo $EC2_INSTANCE_TYPE
EC2_KEYPAIR_NAME="$3"
#echo $EC2_KEYPAIR_NAME
EC2_SECURITY_GROUP_IDS="$4"
#echo $EC2_SECURITY_GROUP_IDS
SUBNET_ID="$5"
#echo $SUBNET_ID

#echo "Desplegando la AMI: $AMI_ID"
#echo "Región: $AWS_REGION"

# Comando para lanzar una instancia EC2 usando la AWS CLI:
aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$EC2_INSTANCE_TYPE" \
    --key-name "$EC2_KEYPAIR_NAME" \
    --security-group-ids "$EC2_SECURITY_GROUP_IDS" \
    --subnet-id "$SUBNET_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=act1-node-nginx}]" \
    --region "$AWS_REGION" \
    --count 1

echo "Instancia EC2 lanzada.  Verifica la consola de AWS para obtener la IP pública."