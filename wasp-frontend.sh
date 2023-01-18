#!/bin/sh
echo "Starting git clone from repository!"
rm -r 2223-frontendweb-RobinBenoot2
git clone https://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@github.com/Web-IV/2223-frontendweb-RobinBenoot2.git
cd 2223-frontendweb-RobinBenoot2
echo "Building the image!"
docker build . --file Dockerfile --tag 192.168.50.5:5000/wasp-frontend:latest
echo "Run container"
docker stop wasp-frontend
docker rm wasp-frontend
docker run --restart unless-stopped -p 5173:5173 -d --name wasp-frontend 192.168.50.5:5000/wasp-frontend:latest 