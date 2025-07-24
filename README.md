#  System Resource Usage Monitor with Email Alerts

A lightweight Bash script to monitor system resources (CPU, Memory, and Disk usage) and send email alerts when predefined thresholds are exceeded.

---

##  Features

- Monitor **CPU**, **Memory**, and **Disk** usage
- Send **email alerts** when usage exceeds user-defined thresholds
- Simple command-line interface
- Compatible with Linux systems
- Uses `msmtp` for email delivery

---

##  Requirements

- `bash`
- `bc`
- `awk`, `sed`, `free`, `top`, `df` (preinstalled in most Linux distros)
- `msmtp` (for sending emails)

Install `msmtp`:

```bash
sudo apt install msmtp
```
create a file at ~/.msmtprc with:
```bash
defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account default
host smtp.gmail.com
port 587
from your-email@gmail.com
user your-email@gmail.com
password your-app-password
logfile ~/.msmtp.log
```
set permissions:
```bash
chmod 600 ~/.msmtprc
```
Usage:
```bash
chmod +x resource_monitor.sh
./resource_monitor.sh
```

 Email Alert Format
You will receive an email like:
```
Subject: Alert: Resource Usage Exceeded Threshold
Warning: The usage of Memory (85%) has exceeded the threshold of 80%.
```

 Author
Karthik B – GitHub


GPL-3.0 license
