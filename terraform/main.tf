provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web" {
  ami                    = "ami-0c94855ba95c71c99"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  tags = {
    Name = "AnsibleWeb"
  }

  provisioner "local-exec" {
    command = "echo [web] > ../ansible/inventory/hosts.ini && echo ${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa >> ../ansible/inventory/hosts.ini"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
