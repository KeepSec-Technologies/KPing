# KPing

## *This bash script makes a cronjob to notify you when one of your hosts is down by curling and/or pinging via user inputs prompts to make the configuration as easy as possible.*

### ***Prerequisites:***

**1)** Install 'expect' to be able to use the autoexpect command:

Debian-based OS: 
```bash
sudo apt-get install -y expect
```
RHEL-based OS: 
```bash
sudo yum install -y expect
```
**2)** Being logged in as root or super-user

**3)** An internet domain pointing to your server, I recommend installing an SPF/DMARC record to pass through some email provider when sending your notifications.

That's it!

### ***What's next:***

**1)** Install the KPing.sh file and make it executable.

To install it: 
```bash
wget https://raw.githubusercontent.com/KeepSec-Technologies/KPing/main/KPing.sh
```
To make it executable:
```bash
sudo chmod +x KPing.sh
```
**2)** Then run: 
```bash
sudo autoexpect -quiet $PWD/KPing.sh
```
***(Very important to use this exact command)***

**3)** Answer the questions like the image below and you're good to go!

![image_2022-07-06_032646001](https://user-images.githubusercontent.com/108779415/177493882-589207f8-f5cb-485e-a27f-0531578b6c24.png)



**Warning: Do not change the path of the 'script.exp' file since the cronjob depends on it.**

If you messed up your input don't worry just rerun the script with autoexpect, it will overwrite everything.

Feel free to modify the code if there's something that you want to change.



