#!/bin/bash

cleanup()
{
    ID=$(($RANDOM))
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    EVENTID="[$TIMESTAMP $ID]"
    echo "$EVENTID Receive shutdown event" >> /home/ec2-user/reboot.log
    cd /home/ec2-user/pdata/docker
    docker-compose stop
    exit 170
}

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

cd /home/ec2-user/pdata/docker
echo "$EVENTID docker-compose up -d" 
NUMBER_NGINX=$(cat /home/ec2-user/pdata/docker/app/number_nginx.txt)
docker-compose up -d --scale app=$NUMBER_NGINX

#get all container IPs
TAGNAME=$(cat /home/ec2-user/pdata/docker/app/tag.txt)
TAGNAME2=$(cat /home/ec2-user/pdata/docker/app/tag2.txt)
echo "TAGNAME:  $TAGNAME"
DATAFILE="/home/ec2-user/efs/ip_list/$TAGNAME.ip.txt"
DATAFILE2="/home/ec2-user/efs/ip_list/$TAGNAME2.ip.txt"
echo "INDEXFILE: $DATAFILE"
HTMLFILE="/home/ec2-user/efs/ip_list/$TAGNAME.html"
echo "HTMLFILE: $HTMLFILE"
touch $DATAFILE
touch $DATAFILE2

trap cleanup SIGKILL SIGTERM
while [ true ]; do
  #DELAY=$(( $RANDOM % 10 ))
  #echo "Delay: $DELAY"
  #sleep $DELAY
  sleep 3

  echo "update the file: $INDEXFILE"
  #sudo docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | grep app | awk -F' ' '{print "<br>"$1}'
  sudo docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | grep app | awk -F' ' '{print "<br>"$1}' > $DATAFILE


  #DATA=$(docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | grep app | awk -F' ' '{print "<br>"$1}')
  DATA=$(cat $DATAFILE)
  echo $DATA
  DATA2=$(cat $DATAFILE2)

  echo "
  <!DOCTYPE html>
  <html>
    <head>
        <title>Prescriptive Data</title>
    </head>
    <body>
        <p>
        <br>Cluster: $TAGNAME
        $DATA
        <br>
        <br>
        <br>Cluster: $TAGNAME2
        $DATA2 

        </p>
    </body>
  </html>
  " > $HTMLFILE


done

