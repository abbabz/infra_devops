provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  default = "my-key"
}

variable "public_key" {
  description = "Clé publique SSH en contenu string"
  type        = string
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id  # récupère le VPC par défaut

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # à restreindre en prod !
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

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "web" {
  ami                         = "ami-0c94855ba95c71c99"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
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
