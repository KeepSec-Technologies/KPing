#!/bin/bash
YEL=$'\e[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m' # No Color
PRPL=$'\033[1;35m'
GRN=$'\e[1;32m'
BLUE=$'\e[3;49;34m'

printf "${BLUE}\n"
echo "██╗  ██╗██████╗ ██╗███╗   ██╗ ██████╗ "
echo "██║ ██╔╝██╔══██╗██║████╗  ██║██╔════╝"
echo "█████╔╝ ██████╔╝██║██╔██╗ ██║██║  ███╗"
echo "██╔═██╗ ██╔═══╝ ██║██║╚██╗██║██║   ██║"
echo "██║  ██╗██║     ██║██║ ╚████║╚██████╔╝"
echo "╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝ ╚═════╝ "
printf "\nPowered by KeepSec Technologies Inc.™\n"
printf "${NC}\n"

sudo -v &> /dev/null || printf "${RED}\nThis script must be run with sudo privileges${NC}\n";
printf "${GRN}\nThis script must be run with 'autoexpect' (see https://github.com/KeepSec-Technologies/KPing)${NC}\n"
sleep 1
echo""
echo ""

read -p "Do you want the script to also curl the hosts? (Y/N) " ynCURL
echo""
read -p "How often in minutes do you want the cron job to run (${YEL}0${NC}-${YEL}60${NC}) : " cron
echo""
read -p "What is the email address that you want to receive your notifications : " to
echo""
read -p "What is the domain that will be used to send emails : " domain
echo""
printf "${GRN}Assure yourself that the domain is pointing to the IP of your server${NC}\n"
echo ""
sleep 1

read -p "What is the (1) IP or website you want to get notifications for : " pinged1
echo""
read -p "Do you want a second ping? (Y/N) " yn1

if [[ $yn1 == Y || $yn1 == y ]]; then 
echo""
read -p "What is the (2) IP or website you want to get notifications for : " pinged2
echo""
read -p "Do you want a third ping? (Y/N) " yn2
echo""
    if [[ $yn2 == Y || $yn2 == y ]]; then 
    read -p "What is the (3) IP or website you want to get notifications for : " pinged3
    echo""
    read -p "Do you want a fourth ping? (Y/N) " yn3
    echo""
      if [[ $yn3 == Y || $yn3 == y ]]; then 
        read -p "What is the (4) IP or website you want to get notifications for : " pinged4
        echo""
        read -p "Do you want a fifth ping? (Y/N) " yn4
        echo""
        if [[ $yn4 == Y || $yn4 == y ]]; then 
        read -p "What is the (5) IP or website you want to get notifications for : " pinged5
        echo""
        fi
      fi
    fi
fi 

if [[ $yn1 == N || $yn1 == n ]]; then 

echo""

fi

sleep 0.5
printf "${PRPL}➜ Installing Postfix and Mailx...${NC}"
echo ""

if [ -n "`command -v apt-get`" ]; then

sudo apt-get -y purge postfix &> /dev/null
sudo echo "postfix postfix/mailname string $domain" | debconf-set-selections
sudo echo "postfix postfix/protocols select  all" | debconf-set-selections
sudo echo "postfix postfix/mynetworks string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128" | debconf-set-selections
sudo echo "postfix postfix/mailbox_limit string  0" | debconf-set-selections
sudo echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
sudo echo "postfix postfix/compat_conversion_warning   boolean true" | debconf-set-selections
sudo echo "postfix postfix/protocols select all" | debconf-set-selections
sudo echo "postfix postfix/procmail boolean false" | debconf-set-selections
sudo echo "postfix postfix/relayhost string" | debconf-set-selections
sudo echo "postfix postfix/chattr boolean false" | debconf-set-selections
sudo echo "postfix postfix/destinations string $domain" | debconf-set-selections

fi

if [ -n "`command -v apt-get`" ];

then sudo apt-get -y install postfix > /dev/null  && sudo apt-get -y install bsd-mailx > /dev/null; 

elif [ -n "`command -v yum`" ]; 

then sudo yum remove -y postfix &> /dev/null && sudo yum install -y postfix > /dev/null  && sudo yum install -y mailx > /dev/null; 

elif [ -n "`command -v pacman`" ];

then sudo pacman -y install postfix > /dev/null  && sudo pacman install -y mailx > /dev/null; 

fi

sudo adduser --disabled-password --gecos "" notification &> /dev/null

if [ -n "`command -v yum`" ]; then

sudo sed -i -e "s/inet_interfaces = localhost/inet_interfaces = all/g" /etc/postfix/main.cf &> /dev/null
sudo sed -i -e "s/#mydomain =.*/mydomain = $domain/g" /etc/postfix/main.cf &> /dev/null 
sudo sed -i -e "s/#myorigin = $mydomain/myorigin = $mydomain/g" /etc/postfix/main.cf &> /dev/null
sudo sed -i -e "s/#mynetworks =.*/mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128/g" /etc/postfix/main.cf &> /dev/null
sudo sed -i -e "s/mydestination =.*/mydestination = mail."'$mydomain'", "'$mydomain'"/g" /etc/postfix/main.cf &> /dev/null
sudo sed -i -e "117d" /etc/postfix/main.cf &> /dev/null

fi

sudo systemctl enable postfix &> /dev/null
sudo systemctl start postfix > /dev/null
sudo systemctl reload postfix > /dev/null


subject1="HOST DOWN: $pinged1"
status1="$(ping -c 4 $pinged1 && curl $pinged1 2>&1)"
status_text1=$(echo "${status1}" | grep -o '100% packet loss')
status_text1CURL=$(echo "${status1}" | grep -o '100% packet loss\|Connection refused')

subject2="HOST DOWN: $pinged2"
if [[ $yn1 == Y || $yn1 == y ]]; then 
status2="$(ping -c 4 $pinged2 && curl $pinged2 2>&1)"
fi
status_text2=$(echo "${status2}" | grep -o '100% packet loss')
status_text2CURL=$(echo "${status2}" | grep -o '100% packet loss\|Connection refused')

subject3="HOST DOWN: $pinged3"
if [[ $yn2 == Y || $yn2 == y ]]; then 
status3="$(ping -c 4 $pinged3 && curl $pinged3 2>&1)"
fi
status_text3=$(echo "${status3}" | grep -o '100% packet loss')
status_text3CURL=$(echo "${status3}" | grep -o '100% packet loss\|Connection refused')

subject4="HOST DOWN: $pinged4"
if [[ $yn3 == Y || $yn3 == y ]]; then 
status4="$(ping -c 4 $pinged4 && curl $pinged4 2>&1)"
fi
status_text4=$(echo "${status4}" | grep -o '100% packet loss')
status_text4CURL=$(echo "${status4}" | grep -o '100% packet loss\|Connection refused')

subject5="HOST DOWN: $pinged5"
if [[ $yn4 == Y || $yn4 == y ]]; then 
status5="$(ping -c 4 $pinged5 && curl $pinged5 2>&1)"
fi
status_text5=$(echo "${status5}" | grep -o '100% packet loss')
status_text5CURL=$(echo "${status5}" | grep -o '100% packet loss\|Connection refused')

#PING-ONLY--------------------------------------
if [[ $ynCURL == N || $ynCURL == n ]]; then

#1
if [[ "${status_text1}" == "100% packet loss" ]]; then

printf "The host '$pinged1' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject1" "$to"

fi

#2
if [[ "${status_text2}" == "100% packet loss" ]]; then

printf "The host '$pinged2' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject2" "$to"

fi

#3
if [[ "${status_text3}" == "100% packet loss" ]]; then

printf "The host '$pinged3' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject3" "$to"

fi

#4
if [[ "${status_text4}" == "100% packet loss" ]]; then

printf "The host '$pinged4' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject4" "$to"

fi

#5
if [[ "${status_text5}" == "100% packet loss" ]]; then

printf "The host '$pinged5' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject5" "$to"

fi

fi

#CURL--------------------------------------------------------
if [[ $ynCURL == Y || $ynCURL == y ]]; then

#curl1
if [[ "${status_text1}" == "100% packet loss" ]] || [[ "${status_text1CURL}" == "Connection refused" ]]; then

printf "The host '$pinged1' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject1" "$to"

fi

#curl2
if [[ "${status_text2}" == "100% packet loss" ]] || [[ "${status_text2CURL}" == "Connection refused" ]]; then

printf "The host '$pinged2' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject2" "$to"

fi

#curl3
if [[ "${status_text3}" == "100% packet loss" ]] || [[ "${status_text3CURL}" == "Connection refused" ]]; then

printf "The host '$pinged3' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject3" "$to"

fi

#curl4

if [[ "${status_text4}" == "100% packet loss" ]] || [[ "${status_text4CURL}" == "Connection refused" ]]; then

printf "The host '$pinged4' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject4" "$to"

fi

#curl5

if [[ "${status_text5}" == "100% packet loss" ]] || [[ "${status_text5CURL}" == "Connection refused" ]]; then

printf "The host '$pinged5' is currently down!\n\n Please check it out as soon as possible." | mail -r "notification" -s "$subject5" "$to"

fi

fi

sudo chmod +x script.exp &> /dev/null

croncmd="/usr/bin/expect $PWD/script.exp &> /dev/null"
cronjob="$cron * * * * $croncmd"

( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

echo ""
printf "${GRN}\nWe're done!${NC}"
echo ""

exit 0