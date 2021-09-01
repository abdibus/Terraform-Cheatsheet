provider "aws" {
  region = "eu-central-1"
}

# The Server
resource "aws_instance" "server" {
  ami                    = data.aws_ami.latest_amazonlinux2usa.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.id # pass public ssh-key to Server
  vpc_security_group_ids = [aws_security_group.server-with-ebs-sg.id]
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Project = var.project
    Owner   = var.owner
  }
}

# Security Groups of the Server
resource "aws_security_group" "server-with-ebs-sg" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Project = var.project
    Owner   = var.owner
  }
}

# ssh-keys needed just for debugging. Then it may be deleted
resource "aws_key_pair" "deployer" {
  public_key = file("./.ssh-keys/ssh-key.pub")
  tags = {
    Project = var.project
    Owner   = var.owner
  }
}
