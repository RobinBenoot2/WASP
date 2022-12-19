#!/bin/sh
echo "Starting git clone from repository!"
rm -r 2223-webservices-RobinBenoot2
git clone https://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@github.com/Web-IV/2223-webservices-RobinBenoot2.git
cd 2223-webservices-RobinBenoot2
echo "Building the image!"
docker build . --file Dockerfile --tag 192.168.50.5:5000/wasp-backend:latest
echo "Run container"
docker stop wasp-backend
docker rm wasp-backend
docker run --restart unless-stopped -p 7000:7000 -d --name wasp-backend 192.168.50.5:5000/wasp-backend:latest 