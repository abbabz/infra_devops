provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  default = "my-key"
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "AnsibleWeb"
  }

  provisioner "local-exec" {
    command = "echo [web] > ../ansible/inventory/hosts.ini && echo ${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa >> ../ansible/inventory/hosts.ini"
  }
}