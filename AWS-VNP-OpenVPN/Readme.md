### Prerequisites
How to Launch OpenVPN-Server on AWS Instance via Terraform.
Here's a simple Terraform template with a boot-strapping/user-data script you may use.

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
- go to admin consul
- configure Network, VPN-Server, users, and get a client
- relax
- 
