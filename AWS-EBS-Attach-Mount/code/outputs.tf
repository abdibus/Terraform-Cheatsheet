output "server-ip" {
  value = aws_instance.server-with-ebs.public_ip
}
