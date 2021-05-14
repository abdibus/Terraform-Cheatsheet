provider "aws" {
  region = var.region
}

# The Server
resource "aws_instance" "vpn-server" {
  ami                    = data.aws_ami.latest_ubuntu18.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.id # pass public ssh-key to Server
  vpc_security_group_ids = [aws_security_group.vpn-server-sg.id]
  user_data              = file("./user_data.sh")
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Project = var.project
    Owner   = var.owner
  }
}

# Security Groups of the Server
resource "aws_security_group" "vpn-server-sg" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 54321
    to_port     = 54321
    protocol    = "udp"
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
