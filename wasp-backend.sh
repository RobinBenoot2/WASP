#!/bin/sh
echo "Starting git clone from repository!"
rm -r 2223-webservices-RobinBenoot2
sh  /home/scripts/authentication.sh
git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/Web-IV/2223-webservices-RobinBenoot2.git
cd 2223-webservices-RobinBenoot2
echo "Building the image!"
docker build . --file Dockerfile --tag 192.168.50.5:5000/wasp-backend:latest
echo "Run container"
docker stop wasp-backend
docker rm wasp-backend
docker run --restart unless-stopped -p 9500:9500 -d --name wasp-backend 192.168.50.5:5000/wasp-backend:latest 