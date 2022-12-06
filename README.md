# KPing

## *This bash script makes a cronjob to notify you when one of your hosts is down by curling and/or pinging via user inputs prompts to make the configuration as easy as possible.*

### ***Prerequisites:***

**1)** Being logged in as root or super-user

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
sudo ./KPing.sh
```

**3)** Answer the questions like the image below and you're good to go!

![image](https://user-images.githubusercontent.com/108779415/206007117-61dddb90-5d3a-40b1-9256-e550e0d03fad.png)

*And we're done!*


The cronjob is in **/etc/cron.d/kping-[DOMAIN]-job** 
The cronjob logs is in **/var/log/kping.log**

If you want to uninstall it do:
```bash
rm -f /etc/cron.d/kping-*
rm -f $HOME/.script/kping-*
```

Feel free to modify the code if there's something that you want to change.
