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

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = aws_key_pair.odoo_key.key_name

  vpc_security_group_ids = [aws_security_group.odoo_sg.id]

  user_data = file("${path.module}/script.sh")

  tags = {
    Name = var.instance_name
  }
}
