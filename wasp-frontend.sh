#!/bin/sh
echo "Starting git clone from repository!"
sh /home/scripts/authentication.sh
if [ -d "/home/scripts/2223-frontendweb-RobinBenoot2" ]; then
  echo "Directory exists."
  cd 2223-frontendweb-RobinBenoot2
  git pull
  cd ..
else
  echo "Directory does not exist."
  git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/Web-IV/2223-frontendweb-RobinBenoot2.git
fi
cd 2223-frontendweb-RobinBenoot2
echo "Building the image!"
docker build . --file Dockerfile --tag 192.168.50.5:5000/wasp-frontend:latest
echo "Run container"
docker stop wasp-frontend
docker rm wasp-frontend
docker run --restart unless-stopped -p 5173:5173 -d --name wasp-frontend 192.168.50.5:5000/wasp-frontend:latest 