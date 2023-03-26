#!/usr/bin/env bash

#~BY YUYU FROM 893CREW~

# ----------------------------------
#-COLORZ-
# ----------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# prepare ufw
# expecting that you are already have it installed but if not kuta will install it for you bruh :/

#~FUNCTION FOR EXISTENSE~
exists()
{
  command -v "$1" >/dev/null 2>&1
}


#~CHECKING FOR UFW~
echo " "
read -p 'Checking for ufw, if it installed. If not, i will install it for you - y/n: ' lzt

if
  [ "$lzt" == "n" ]
then
  echo 'Fuck you then.'
  exit
fi

if
  exists git && [ "$lzt" == "y" ]; then
  printf "${GREEN}Ufw found!${NOCOLOR}"
  echo " "
else
  ! exists ufw
  printf "${RED}Ufw not found.${NOLOCOR} Installing."
  apt install ufw -y 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}" " "
  sleep .1
done

  printf "${GREEN}Successful!${NOCOLOR}"
  echo " "
  echo 'Now you have ufw.'
fi

sudo ufw disable
sudo ufw reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
echo " "
echo "We have already set a rule that allows ssh  traffic so dont be shie and press - yes"
echo " "
sudo ufw enable

# allow all traffic from Cloudflare IPs (no ports restriction or smth like that)
echo " "
echo " Allowing all traffic for cf ips"
for cfip in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6} && curl -sw '\n' https://www.cloudflare.com/ips-v{4,6} >> /tmp/cf_ips`; do ufw allow proto tcp from $cfip comment 'Cloudflare IP'; done

ufw reload > /dev/null

# here our rules go, its examples for 80 and 443 btw

# retrict to port 80
#for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip to any port 80 comment 'Cloudflare IP'; done

# restrict to port 443
#for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip to any port 443 comment 'Cloudflare IP'; done

# restrict to ports 80 & 443
echo " "
echo " Restricting access to ports 80 and 443. Only allow cf ips ^//^"
for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip to any port 80,443 comment 'Cloudflare IP'; done

read -p 'Do you want to add this script as cron job, so you can grab fresh cf ips - y/n: ' tlz

if
  [ "$tlz" == "n" ]
then
  echo 'k then, im done here, cya honey.'
  exit
fi

if
  [ "$tlz" == "y" ]; then
  
  #~CHECKING FOR CRONTAB~
echo " "
read -p 'Checking for ufw, if it installed. If not, i will install it for you'
  exists crontab && [ "$lzt" == "y" ]; then
  printf "${GREEN}Ufw found!${NOCOLOR}"
  echo " "
else
  ! exists crontab
  printf "${RED}cron not found.${NOLOCOR} Installing."
  apt install cron -y 2>/dev/null &
pid=$! # Process Id of the previous running command

spin='-\|/'

i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r${spin:$i:1}" " "
  sleep .1
done

  printf "${GREEN}Successful!${NOCOLOR}"
  echo " "
  echo 'Now you have cron.'
  echo " "
  printf "${GREEN}Updating cron file!${NOCOLOR}"
  echo " "
  echo "the script you are running has very unique name - $( basename -- "$0"; ), dirname $( dirname -- "$0"; )";
  echo "the present working directory is $( pwd; )";
  echo "above info that im need to add this script as cron job, dont worry :0"
  (crontab -l ; echo '0 0 * * 1 /$pwd/cloudflare-ufw.sh > /dev/null 2>&1') | crontab
  echo " "
  echo "done, now you will automatically get updates cf ips!"
else
  echo "${RED}Da fuck do ya mean crackhead?!.${NOLOCOR}"
fi
