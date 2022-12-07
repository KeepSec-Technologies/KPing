#!/bin/bash
YEL=$'\e[1;33m' # Yellow
RED=$'\033[0;31m' # Red
NC=$'\033[0m' # No Color
PRPL=$'\033[1;35m' # Purple
GRN=$'\e[1;32m' # Green
BLUE=$'\e[3;49;34m' # Blue 

#script logo with copyrights
printf "${BLUE}\n"
echo "██╗  ██╗██████╗ ██╗███╗   ██╗ ██████╗ "
echo "██║ ██╔╝██╔══██╗██║████╗  ██║██╔════╝"
echo "█████╔╝ ██████╔╝██║██╔██╗ ██║██║  ███╗"
echo "██╔═██╗ ██╔═══╝ ██║██║╚██╗██║██║   ██║"
echo "██║  ██╗██║     ██║██║ ╚████║╚██████╔╝"
echo "╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝ ╚═════╝ "
printf "\nPowered by KeepSec Technologies Inc.™\n"
printf "${NC}\n"

#check if root or not
if [ `id -u` -ne 0 ]; then
      printf "${RED}\nThis script can only be executed as root\n\n${NC}"
      sleep 0.5
      exit
   fi
sleep 1
mkdir $HOME/.script &> /dev/null
printf "\n"

#variables for number of questions
num=1

#variables of quotes to output secondary scripts well
sqt="'"
dqt='"'

#function to ask if you want to curl the hosts or not
function askCurl { 
  read -n 1 -p "Do you want the script to also ${YEL}curl${NC} the hosts? (Y/N) " ynCURL
  case $ynCURL in
    [yY] )
    echo ""
    ;;
    [nN] )
    echo ""
    ;;
    *)
    printf "${RED}\nAnswer 'Y' or 'N', try again\n\n${NC}"
    sleep 0.5
    askCurl
    ;;
  esac
  echo""
}
#function to ask frequence of checking the hosts (min 1 minute, max 60 minutes)
function askFreq {
  read -n 2 -p "How often in ${YEL}minutes${NC} do you want the cron job to run (1-60) : " cron
  case $cron in
    [1-60] )
    echo ""
    ;;
    *)
    printf "${RED}\nOnly numbers between 1 and 60, try again\n\n${NC}"
    sleep 0.5
    askFreq
    ;;
  esac
}
#function to ask for another monitor or not
function askMonit {
  read -n 1 -p "Do you want another ping (${YEL}${num}${NC})? (Y/N) " yn
  case $yn in
    [yY] )
    printf "\n\n"
    ;;
    [nN] )
    printf "\n\n"
    return 1
    ;;
    *)
    printf "${RED}\nAnswer 'Y' or 'N', try again\n\n${NC}"
    sleep 0.5
    askMonit
    ;;
  esac
}

#start of series of questions
askCurl
askFreq
#email address to receive the notifs
read -p "What is the ${YEL}email${NC} address that you want to receive your notifications : " to
echo""
#internet domain pointing to your server to send emails
read -p "What is the ${YEL}domain${NC} that will be used to send emails : " domain
echo""
printf "${GRN}Assure yourself that the domain is pointing to the IP of your server${NC}\n"
echo""
sleep 1
#loop for infinite questions to add as many hosts as you want
while :
do
    read -p "What is the (${YEL}${num}${NC}) IP or website you want to get notifications for : " pingedloop
    echo""
    #PING-ONLY--------------------------------------
    if [[ $ynCURL == N || $ynCURL == n ]]; then
        echo -e "#!/bin/bash
        subject=${dqt}HOST DOWN: $pingedloop${dqt}
        status=${dqt}\$(ping -c 4 $pingedloop && curl $pingedloop 2>&1)${dqt}
        status_text=\$(echo ${dqt}\${status}${dqt} | grep -o ${sqt}100% packet loss${sqt})
        if [[ ${dqt}\${status_text}${dqt} == ${dqt}100% packet loss${dqt} ]]; then
        printf ${dqt}The host ${sqt}$pingedloop${sqt} is currently down!\n\n Please check it out as soon as possible.${dqt} | mail -r ${dqt}notification${dqt} -s ${dqt}\$subject${dqt} ${dqt}$to${dqt}
        fi" > $HOME/.script/kping-$pingedloop-job.sh
        croncmd="root /usr/bin/bash $HOME/.script/kping-$pingedloop-job.sh >> /var/log/kping.log"
        cronjob="*/$cron * * * * $croncmd"
        printf "$cronjob\n" > "/etc/cron.d/kping-$pingedloop-job"
    #CURL--------------------------------------------------------
    elif [[ $ynCURL == Y || $ynCURL == y ]]; then
        echo -e "#!/bin/bash
        subject=${dqt}HOST DOWN: $pingedloop${dqt}
        status=${dqt}\$(ping -c 4 $pingedloop && curl $pingedloop 2>&1)${dqt}
        status_text=\$(echo ${dqt}\${status}${dqt} | grep -o ${sqt}100% packet loss${sqt})
        status_textCURL=\$(echo ${dqt}${status}${dqt} | grep -o ${sqt}100% packet loss\|Connection refused${sqt})
        if [[ ${dqt}\${status_text}${dqt} == ${dqt}100% packet loss${dqt} ]] || [[ ${dqt}\${status_textCURL}${dqt} == ${dqt}Connection refused${dqt} ]]; then
        printf ${dqt}The host ${sqt}$pingedloop${sqt} is currently down!\n\n Please check it out as soon as possible.${dqt} | mail -r ${dqt}notification${dqt} -s ${dqt}\$subject${dqt} ${dqt}$to${dqt}
        fi" > $HOME/.script/kping-$pingedloop-job.sh
        croncmd="root /usr/bin/bash $HOME/.script/kping-$pingedloop-job.sh >> /var/log/kping.log"
        cronjob="*/$cron * * * * $croncmd"
        printf "$cronjob\n" > "/etc/cron.d/kping-$pingedloop-job"
    fi
    num=$((num+1))
    askMonit || break
done

#function for the installing wheel
function installing {
  tput civis
  spinner="⣾⣽⣻⢿⡿⣟⣯⣷"
  while :
  do
    for i in `seq 0 7`
    do
      printf "${PRPL}${spinner:$i:1}"
      printf "\010${NC}"
      sleep 0.2
    done
  done
}

#executes function above
installing &
SPIN_PID=$!
disown
printf "${PRPL}\nInstalling utilities ➜ ${NC}"

#checks package manager and then install all the necessary utilities with your right package manager + puts the right configuration in the config file for postfix for you
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
then sudo pacman -S postfix > /dev/null  && sudo pacman -S mailx > /dev/null; 
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

#enable postfix mail services
sudo systemctl enable postfix &> /dev/null
sudo systemctl start postfix &> /dev/null
sudo systemctl reload postfix &> /dev/null

#kills spinning wheel
kill -9 $SPIN_PID &> /dev/null
tput cnorm
echo ""
#bye bye message :)
printf "${GRN}\n\nWe're done!${NC}"
echo ""

exit 0
