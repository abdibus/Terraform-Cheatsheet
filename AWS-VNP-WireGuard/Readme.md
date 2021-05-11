### Prerequisites
How to Launch WireGuard VPN-Server on AWS Instance via Terraform.
<br>
Here's a simple Terraform template with a boot-strapping/user-data script you may use.
It works for me and I find it useful for others.

### Commands to execute
Create ssh-keys to connect the server:
```
mkdir .ssh-keys
ssh-keygen
```
Launch VPN-Server using Terraform:
```
cd Terraform-Cheatsheet/AWS-VNP-WireGuard/
./vpn-server apply
```
Add a user on remote-server:
```
cd wireguard_aws/
sudo sh add-client.sh
```
Destroy VPN-Server using Terraform:
```
cd Terraform-Cheatsheet/AWS-VNP-WireGuard/
./vpn-server destroy
```
#### Resulting screenshots
ssh-connect && result confirmation:
<img src="instance.png"><br>
### Links of used resources
<a href="https://github.com/pprometey/wireguard_aws">Alexey Chernyavskiy Github</a>
<br>
<a href="https://habr.com/ru/post/448528/">Article about deployment in Russian.</a>

### Issues
- It takes about extra 10 seconds for `user_data.sh` to be completed after ssh-connect. Please wait.
- In different regions, the value of AMI filter in `data.tf` may differ.

- I have Terraform version of `Terraform v0.15.0`. In earlier versions, especially in v0.12 and older ones, it will not work.