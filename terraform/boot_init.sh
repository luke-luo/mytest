#!/bin/bash

EFSNAME=$(cat /home/ec2-user/efs_name.txt)
echo $EFSNAME

LogFile=/home/ec2-user/mnt.log
EFSDir=/home/ec2-user/efs

sudo mkdir -p $EFSDir > $LogFile
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFSNAME:/ $EFSDir >> $LogFile
echo $? > $LogFile
sudo chown -R ec2-user $EFSDir >> $LogFile
df -h >>$LogFile

cd /home/ec2-user/pdata/docker

docker ps

docker-compose up -d --scale app=6
#docker-compose scale app=6

#@reboot sudo -u ec2-user /home/ec2-user/boot_init.sh >> /var/log/script_output.log 2>&1
#sudo crontab -e