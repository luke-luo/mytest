#!/bin/sh

/tmp/get_all_ip.sh
nginx

#ip route get 1 | awk '{print $NF;exit}'
cleanup()
{
  MYIP=$(ip route get 1 | awk '{print $NF;exit}')
  echo $MYIP
  sed -i -e "s/$MYIP//g" /mydata/all_ip.txt
  sed -i '/^$/d' /mydata/all_ip.txt
  echo "Catch the shutdown event" > /mydata/evt.txt
  exit 170
}

#trap 'exit 0' SIGTERM

trap cleanup SIGKILL SIGTERM
while true; do :; done