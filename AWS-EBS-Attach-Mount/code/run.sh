#!/bin/bash
sudo yum -y update
sudo yum -y upgrade

# The best way is to run that script after \resource "aws_volume_attachment"\ created
sleep 120

# Format and mount an attached volume
DEVICE=/dev/$(lsblk -rno NAME | awk 'FNR == 3 {print}')
MOUNT_POINT=/data/
mkdir $MOUNT_POINT
yum -y install xfsprogs
mkfs -t xfs $DEVICE
mount $DEVICE $MOUNT_POINT

# Automatically mount an attached volume after reboot / For the current task it's not obligatory
cp /etc/fstab /etc/fstab.orig
UUID=$(blkid | grep $DEVICE | awk -F '\"' '{print $2}')
echo -e "UUID=$UUID     $MOUNT_POINT      xfs    defaults,nofail   0   2" >> /etc/fstab
umount /data
mount -a

# Change user for data operations / Non mandatory
chown -R ec2-user:ec2-user $MOUNT_POINT
su ec2-user
