# Get Amazon-Linux-2 Latest-AMI
data "aws_ami" "latest_amazonlinux2usa" {
  owners      = ["amazon"] #["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-gp2"]
  }
}
