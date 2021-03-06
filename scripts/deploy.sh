#!/bin/bash
# install AWS SDK
pip install awscli
export PATH=$PATH:$HOME/.local/bin

# install necessary dependency for ecs-deploy
sudo add-apt-repository ppa:eugenesan/ppa -y
sudo apt-get update -y
sudo apt-get install jq -y

# install ecs-deploy
curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | \
  sudo tee -a /usr/bin/ecs-deploy \
  sudo chmod +x /usr/bin/ecs-deploy

# login AWS ECR
eval $(aws ecr get-login --no-include-email --region ${AWS_DEFAULT_REGION})

# build the docker image and push to an image repository
docker --version
docker tag demo/ecs-auto-deploy:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${ECR_IMAGE_TAG}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${ECR_IMAGE_TAG}

# update an AWS ECS service with the new image
ecs-deploy -c $ECS_CLUSTER_NAME -n $ECS_SERIVCE_NAME -i ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${ECR_IMAGE_TAG}