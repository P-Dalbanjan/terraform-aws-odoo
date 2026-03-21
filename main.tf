data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_key_pair" "odoo_key" {
  key_name   = "Odoo-Instance-Key"
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

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type[2]

  key_name = aws_key_pair.odoo_key.key_name

  vpc_security_group_ids = [aws_security_group.odoo_sg.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_eip" "odoo_ip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
  tags = {
    Name = "odoo-eip"
  }
}
