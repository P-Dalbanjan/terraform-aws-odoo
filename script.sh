#!/bin/bash
set -ex

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

# Give ubuntu access to docker
usermod -aG docker ubuntu

# -----------------------------
# Run app setup as ubuntu user
# -----------------------------
sudo -u ubuntu -i <<'EOF'

git clone https://github.com/P-Dalbanjan/odoo-docker.git
cd odoo-docker

# Generate secure password
openssl rand -base64 24 > odoo_pg_pass
chmod 644 odoo_pg_pass

# Start services
docker compose up -d

EOF

echo "Setup complete"
