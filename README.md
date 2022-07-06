# KPing

## *This bash script makes a cronjob to notify you when one of your hosts is down by curling and/or pinging via user inputs prompts to make the configuration as easy as possible.*

### ***Prerequisites:***

**1)** Install 'expect' to be able to use the autoexpect command:

Debian-based OS: **sudo apt-get install -y expect**

RHEL-based OS: **sudo yum install -y expect**

Arch-based OS: **sudo pacman install -y expect**

**2)** Being logged in as root or super-user

**3)** An internet domain pointing to your server, I recommend installing an SPF/DMARC record to pass through some email provider when sending your notifications.

That's it!

### ***What's next:***

**1)** Install the KPing.sh file and make it executable.

To install it: 

**wget https://raw.githubusercontent.com/KeepSec-Technologies/KPing/main/KPing.sh**

To make it executable:

**sudo chmod +x KPing.sh**

**2)** Then run: 

**sudo autoexpect -quiet $PWD/KPing.sh** 

***(Very important to use this exact command)***

**3)** Answer the questions like the image below and you're good to go!




**Warning: Do not change the path of the 'script.exp' file since the cronjob depends on it.**

If you messed up your input don't worry just rerun the script with autoexpect, it will overwrite everything.

Feel free to modify the code if there's something that you want to change.



