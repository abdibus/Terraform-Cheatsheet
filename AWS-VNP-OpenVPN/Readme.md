### Prerequisites
How to Launch OpenVPN-Server on AWS Instance via Terraform.
Here's a simple Terraform template with a <a href="https://openvpn.net/vpn-software-packages/">user-data</a> applied to AWS Linux-2 instance.

### Commands to execute
Create ssh-keys:
```
mkdir .ssh-keys
ssh-keygen
// choose ssh-key
```
Terraform commands:
```
terraform init
terraform plan
terraform apply

terraform destroy
```

You have to set password for `openvpn` admin-user by ssh-connect:
```
ssh -i .ssh-keys/ssh-key ec2-user@<public-ip>
// sudo passwd openvpn
```
### Result
- Go to admin consul
- Configure Network, VPN-Server, users, and get VPN-Client
- Relax
