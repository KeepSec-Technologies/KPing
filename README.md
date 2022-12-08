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
chmod +x KPing.sh
```
**2)** Then run: 
```bash
./KPing.sh
```

**3)** Answer the questions like the image below and you're good to go!

![image](https://user-images.githubusercontent.com/108779415/206007117-61dddb90-5d3a-40b1-9256-e550e0d03fad.png)

*And we're done!*


The cronjob is in **/etc/cron.d/kping-[DOMAIN]-job** 

The cronjob logs is in **/etc/KPing/logs**

If you want to remove only the configurations re-run the script and it will ask you for this:
![image](https://user-images.githubusercontent.com/108779415/206327775-385a3a49-bcd3-4c53-92f7-03426704578c.png)

If you want to uninstall completely it do:
```bash
rm -f /etc/cron.d/kping-*
rm -fr /etc/KPing
```

Feel free to modify the code if there's something that you want to change.
