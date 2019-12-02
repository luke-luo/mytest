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


  sed -i -e "s/$MYIP//g" /mydata/ip_list/$TAGNAME.txt
  sed -i '/^$/d' /mydata/ip_list/$TAGNAME.txt
  echo "Catch the shutdown event" > /mydata/evt.txt
  exit 170
}

#trap 'exit 0' SIGTERM

trap cleanup SIGKILL SIGTERM
while true; do :; done