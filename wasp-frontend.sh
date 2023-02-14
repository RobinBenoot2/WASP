#!/bin/sh
echo "Starting git clone from repository!"
if [ -d "/home/repo/wasp-frontend/2223-frontendweb-RobinBenoot2" ]; then
  echo "Directory exists."
  cd 2223-frontendweb-RobinBenoot2
  git pull
else
  echo "Directory does not exist."
  cd /home/repo/wasp-frontend
  git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/Web-IV/2223-frontendweb-RobinBenoot2.git
  cd 2223-frontendweb-RobinBenoot2
fi
echo "Building the image!"
docker build . --file Dockerfile --tag 192.168.50.5:5000/wasp-frontend:latest
echo "Run container"
docker stop wasp-frontend
docker rm wasp-frontend
docker run --restart unless-stopped -p 5173:5173 -d --name wasp-frontend 192.168.50.5:5000/wasp-frontend:latest 