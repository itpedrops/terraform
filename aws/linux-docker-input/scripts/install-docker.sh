#!/bin/bash
sudo yum update -y
sudo yum install docker.x86_64 -y
sudo chkconfig docker on
sudo service docker start 
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo docker pull php:7-fpm
sudo docker pull nginx:latest
sudo usermod -a -G docker ec2-user

## Configurar EBS
sudo fdisk /dev/xvdb << EE0F
n
p
1


t
8e
w
EE0F
sudo mkdir /home/ec2-user/cliente1
sudo pvcreate -v /dev/xvdb1
sudo vgcreate cliente1 /dev/xvdb1
sudo lvcreate -L 17G -n cliente1lv cliente1
sudo mkfs -t ext4 /dev/cliente1/cliente1lv
sudo mount -t ext4 /dev/cliente1/cliente1lv /home/ec2-user/cliente1
sudo chmod 777 /etc/fstab
sudo echo "/dev/cliente1/cliente1lv /home/ec2-user/cliente1 ext4 defaults 0 0" >> /etc/fstab
sudo chmod 644 /etc/fstab
sudo chown -R 1000:1000 /home/ec2-user/
sudo cp /home/ec2-user/docker-compose.yaml /home/ec2-user/cliente1/
sudo /usr/bin/docker-compose -f /home/ec2-user/cliente1/docker-compose.yaml up -d
sudo cp /home/ec2-user/default.conf /home/ec2-user/cliente1/conf/
sudo cp /home/ec2-user/index.php /home/ec2-user/cliente1/code/ 

