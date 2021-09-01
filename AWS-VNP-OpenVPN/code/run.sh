#!/bin/bash
sudo yum -y update
sudo yum -y upgrade
yum -y remove openvpn-as-yum
yum -y install https://as-repository.openvpn.net/as-repo-amzn2.rpm
yum -y install openvpn-as
