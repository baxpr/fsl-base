#!/bin/bash

fsl_version="6.0.7.18"
docker_user="baxterprogers"
docker_tag="${docker_user}/fsl-base:v${fsl_version}"

docker build --build-arg FSLVER="${fsl_version}"  -t "${docker_tag}" .
