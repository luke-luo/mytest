#!/bin/bash

EFSNAME=$(cat /home/ec2-user/efs_name.txt)
echo $EFSNAME

LogFile=/home/ec2-user/mnt.log
EFSDir=/home/ec2-user/efs

#mount EFS
sudo mkdir -p $EFSDir > $LogFile
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFSNAME:/ $EFSDir >> $LogFile
echo $? > $LogFile
sudo chown -R ec2-user $EFSDir >> $LogFile
df -h >>$LogFile

#get ready for IP List
TAGNAME=$(cat /home/ec2-user/pdata/docker/app/tag.txt)
mkdir -p /home/ec2-user/efs/ip_list

sudo rm -f /home/ec2-user/efs/ip_list/$TAGNAME.txt

#start docker
cd /home/ec2-user/pdata/docker
docker ps
NUMBER_NGINX=$(cat /home/ec2-user/pdata/docker/app/number_nginx.txt)
docker-compose build
docker-compose up -d --scale app=$NUMBER_NGINX
