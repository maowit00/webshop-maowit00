#!/bin/sh

if command -v docker
then
	echo
	echo "Docker already installed ..."
	echo
	echo

	exit 0
fi

# DOC SOURCE https://docs.docker.com/engine/install/ubuntu

# Uninstall old versions

sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)

# Install using the apt repository

set -xe

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Setup as a service

sudo systemctl enable --now docker

# Setup group permission

if [ -z $(getent group docker) ]
then
	sudo groupadd docker
fi

sudo usermod -aG docker $USER

# Most likely won't work till restart. Linux Groups :/

sudo docker run --rm hello-world

