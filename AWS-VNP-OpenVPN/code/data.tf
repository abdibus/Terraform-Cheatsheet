# Latest Ubuntu 18.04
data "aws_ami" "latest_awslinux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*"]
  }
}
