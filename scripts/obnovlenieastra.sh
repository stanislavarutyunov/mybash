#!/bin/bash
mkdir /mnt/1 /mnt/2 /mnt/3
mount /dev/sr0 /mnt/1
mount /dev/sr1 /mnt/2
mount /dev/sr2 /mnt/3
echo "deb file:///mnt/1 1.7_x86-64 main contrib non-free
deb file:///mnt/2 1.7_x86-64 main contrib non-free
deb file:///mnt/3 1.7_x86-64 main contrib non-free" > /etc/apt/sources.list
apt-get update
apt install astra-update
astra-update -a -r
apt-get upgrade
sudo apt autoremove
sudo reboot
