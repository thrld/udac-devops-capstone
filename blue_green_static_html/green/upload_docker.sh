#!/usr/bin/env bash

# This file tags and uploads an image to Docker Hub
# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
DOCKER_USER=thrld
IMAGE_NAME=greenimage
DOCKER_PATH=$DOCKER_USER/$IMAGE_NAME

# Step 2:
# Authenticate & tag
echo "Docker ID and Image: $DOCKER_PATH"
docker login --username $DOCKER_USER
docker tag $IMAGE_NAME $DOCKER_PATH

# Step 3:
# Push image to a docker repository
sudo docker push $DOCKER_PATH
