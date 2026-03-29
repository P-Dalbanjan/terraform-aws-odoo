#!/bin/bash
set -e

# -----------------------------
# System update & prerequisites
# -----------------------------
sudo apt update -y

# -----------------------------
# Docker installation setup
# Adds official Docker repository,
# installs Docker engine + tools,
# and enables the service
# -----------------------------
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

# -----------------------------
# Git installation & repo setup
# Clones the Odoo Docker project
# -----------------------------
sudo apt install -y git
git clone https://github.com/P-Dalbanjan/odoo-docker.git
cd odoo-docker

# -----------------------------
# Secure PostgreSQL password setup
# Generates a strong random password
# and restricts file permissions
# -----------------------------
openssl rand -base64 24 > odoo_pg_pass
chmod 600 odoo_pg_pass

# -----------------------------
# Start Odoo services
# Runs containers in detached mode
# -----------------------------
sudo docker compose up -d

echo "Setup complete"
