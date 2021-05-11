#!/bin/bash
git clone https://github.com/pprometey/wireguard_aws.git /home/ubuntu/wireguard_aws
chown -R ubuntu:ubuntu /home/ubuntu/wireguard_aws

# remove.sh
cd /home/ubuntu/wireguard_aws && sh remove.sh

# install.sh
apt install software-properties-common -y
add-apt-repository ppa:wireguard/wireguard -y
apt update
apt install wireguard-dkms wireguard-tools qrencode -y

NET_FORWARD="net.ipv4.ip_forward=1"
sysctl -w  ${NET_FORWARD}
sed -i "s:#${NET_FORWARD}:${NET_FORWARD}:" /etc/sysctl.conf

cd /etc/wireguard
umask 077

SERVER_PUBKEY=$( echo $SERVER_PRIVKEY | wg pubkey )
echo $SERVER_PUBKEY > ./server_public.key

SERVER_PRIVKEY=$( wg genkey )
echo $SERVER_PRIVKEY > ./server_private.key

ENDPOINT=$(host myip.opendns.com resolver1.opendns.com | grep "myip.opendns.com has" | awk '{print $4}')
echo "$ENDPOINT:54321" > ./endpoint.var

SERVER_IP="10.50.0.1"
echo $SERVER_IP | grep -o -E '([0-9]+\.){3}' > ./vpn_subnet.var

DNS="1.1.1.1"
echo $DNS > ./dns.var
echo 1 > ./last_used_ip.var
WAN_INTERFACE_NAME="eth0"
echo $WAN_INTERFACE_NAME > ./wan_interface_name.var

cat ./endpoint.var | sed -e "s/:/ /" | while read SERVER_EXTERNAL_IP SERVER_EXTERNAL_PORT
do
cat > ./wg0.conf.def << EOF
[Interface]
Address = $SERVER_IP
SaveConfig = false
PrivateKey = $SERVER_PRIVKEY
ListenPort = $SERVER_EXTERNAL_PORT
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $WAN_INTERFACE_NAME -j MASQUERADE;
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $WAN_INTERFACE_NAME -j MASQUERADE;
EOF
done

cp -f ./wg0.conf.def ./wg0.conf

systemctl enable wg-quick@wg0
