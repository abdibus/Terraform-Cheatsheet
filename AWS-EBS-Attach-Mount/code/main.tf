provider "aws" {
  region = "us-east-2"
}

# The Server
resource "aws_instance" "server-with-ebs" {
  ami                    = data.aws_ami.latest_amazonlinux2usa.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.id # pass public ssh-key to Server
  vpc_security_group_ids = [aws_security_group.server-with-ebs-sg.id]
  user_data              = file("./run.sh")
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
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

# EBS-volume of Server. 500Gb Troughtoutput Optimized HDD, i.e. st1
resource "aws_ebs_volume" "data-storage" {
  availability_zone = aws_instance.server-with-ebs.availability_zone
  size              = 500
  type              = "st1"
  tags = {
    Project = var.project
    Owner   = var.owner
  }
}

# Attachment Server to EBS-volume
resource "aws_volume_attachment" "ebs_att" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.data-storage.id
  instance_id  = aws_instance.server-with-ebs.id
  force_detach = true
}
