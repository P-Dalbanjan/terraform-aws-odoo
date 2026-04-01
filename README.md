# ☁️ Odoo Deployment on AWS using Terraform

This repository contains **Terraform configuration** to automate the deployment of an **Odoo application** on an **Amazon EC2 instance**.

The setup uses the **default AWS VPC** and is designed for a **single-instance deployment**, making it well-suited for **small-to-medium environments**.

It is built to be:

* ✅ Simple and easy to manage
* ⚙️ Fully automated using Terraform
* 🚀 Quick to provision and deploy

Ideal for **learning**, **development**, and **lightweight production use cases**.

---

# 🏗️ Architecture Overview

The deployment provisions AWS infrastructure and configures the server automatically:

![Architechtural Diagram of Odoo using Terraform.](./assets/architechture.png)

* **AWS EC2 Instance**
  Runs an Ubuntu server (`t3.small` by default) to host the application.

* **Security Group**
  Acts as a firewall that allows HTTP traffic from all public IPs (0.0.0.0/0) and restricts SSH access exclusively to your current IP address.

* **Automated Provisioning (User Data)**
  A startup script automatically installs Docker, clones the Odoo Docker repository, generates a secure database password, and starts the containers.

---

# 🚀 Quick Start

## 1. Prerequisites

Ensure the following tools are installed:

* [Terraform](https://developer.hashicorp.com/terraform/downloads) (requires version `~> 6.0` for the AWS provider)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with your credentials.

---

## 2. Clone the Repository

```bash
git clone https://github.com/P-Dalbanjan/terraform-aws-odoo.git
cd terraform-aws-odoo
```

---

## 3. Configure the SSH Key

Create an SSH public key file named `odoo-key.pub` in the root directory. This key is ignored by version control to protect your credentials but is required to provision the EC2 key pair.

```bash
ssh-keygen -t ed25519 -f ./odoo-key
# The generated odoo-key.pub will be used by Terraform
```

---

## 4. Initialize and Apply

Launch the infrastructure:

```bash
terraform init
terraform apply
```

Terraform will calculate the required changes and prompt you to confirm. Type `yes` to proceed.

---

## 5. Access Odoo

Once the deployment finishes, Terraform will output the `instance_public_ip`. Open your browser and visit:

```text
http://<instance_public_ip>
```

You should see the **Odoo database setup page**. Note that the startup script may take a few minutes to complete in the background after the EC2 instance boots.

---

# ⚙️ Configuration

## Variables

You can customize the deployment by modifying the `variables.tf` file or overriding them in a `.tfvars` file. Note that `.tfvars` files are excluded from version control because they are subject to change depending on the environment and often contain sensitive data.

| Variable        | Description                                      | Default          |
| :-------------- | :----------------------------------------------- | :--------------- |
| `instance_name` | Name tag for the EC2 instance                    | `odoo-terraform` |
| `instance_type` | EC2 instance type (must be `t3.small` or larger) | `t3.small`       |

---

## Terraform State Backend

By default, the state is configured to be stored remotely in an AWS S3 bucket (`tfstate-852857243302-us-east-1-an`) in the `us-east-1` region. You will need to update this to your own bucket or remove the `backend "s3"` block to store state locally before running `terraform init`.

---

## Outputs

After a successful apply, Terraform provides several outputs:

* `instance_public_ip`: The public IP address of the web server.
* `instance_hostname`: The private DNS name of the EC2 instance.
* `instance_security_group_ids`: The VPC security group IDs attached to the instance.
* `instance_subnet`: The subnet ID where the instance was deployed.

---

# 🔧 Useful Commands

Initialize Terraform:

```bash
terraform init
```

Preview changes without applying:

```bash
terraform plan
```

Apply infrastructure changes:

```bash
terraform apply
```

Tear down all provisioned infrastructure:

```bash
terraform destroy
```

---

# 🔐 Security Notes

For production deployments consider adding:

* HTTPS with TLS certificates (via a Load Balancer or Nginx reverse proxy).
* More restrictive IAM profiles for the EC2 instance.
* Automated database backups.

This setup already includes:

* Dynamic SSH restriction via the `checkip.amazonaws.com` data source to only allow port 22 access from your deployment IP.
* Automatic secure password generation for PostgreSQL (`openssl rand -base64 24 > odoo_pg_pass`) inside the setup script.
* Explicit `.gitignore` rules to prevent `*.tfvars` files and local SSH keys from being pushed to version control.

---

# ⚖️ License

This free and unencumbered software is released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

More details:
[https://unlicense.org](https://unlicense.org)
