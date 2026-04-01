data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_key_pair" "odoo_key" {
  key_name   = "odoo-terraform-key"
  public_key = file("odoo-key.pub") # add your own key.pub
}

resource "aws_security_group" "odoo_sg" {
  name        = "odoo-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open to all (public access)
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # allow all outbound
  }

  tags = {
    Name = "odoo-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.odoo_key.key_name
  instance_type               = var.instance_type
  user_data                   = file("${path.module}/script.sh")
  vpc_security_group_ids      = [aws_security_group.odoo_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}
