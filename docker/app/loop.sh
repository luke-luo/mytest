#!/bin/sh

/tmp/get_all_ip.sh
nginx

#ip route get 1 | awk '{print $NF;exit}'
cleanup()
{
  MYIP=$(ip route get 1 | awk '{print $NF;exit}')
  echo $MYIP

  HOSTIP=$(cat /www/host_ips.txt)
  echo "HOSTIP:" $HOSTIP

  TAGNAME=$(cat /www/tag.txt)
  echo "TAGNAME:" $TAGNAME



############Lock###########
MYLOCK=/mydata/ip_list/$TAGNAME.lock
# stop on errors
#set -e

for i in $(seq 1 10); do

#SEC_WAIT=$(printf "0.%04d\n" $(( RANDOM % 1000 )))

# lock it
exec 200>$MYLOCK
flock -n 200
retVal=$?
if [ $retVal -eq 0 ]; then
  echo "Terminator get the file lock"

  sed -i -e "s/$MYIP//g" /mydata/ip_list/$TAGNAME.txt
  sed -i '/^$/d' /mydata/ip_list/$TAGNAME.txt
  echo "Catch the shutdown event" > /mydata/evt.txt

  pid=$$
  echo $MYIP 1>&200

  exit 170
fi

echo "Terminator can not get the file lock, retry"
sleep 2

done

exit 170

}

#trap 'exit 0' SIGTERM

trap cleanup SIGKILL SIGTERM
while true; do 
sleep 5 
done