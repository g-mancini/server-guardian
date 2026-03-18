# Server Guardian

Server Guardian is a lightweight server monitoring and automation toolkit built with Bash and Flask.
It collects system metrics, exposes them through a web dashboard, and runs automatically on a remote server (e.g. AWS EC2).

---

## Overview

This project combines:

* A Bash script for system monitoring and automation
* A Flask web application for visualization
* Cron for periodic execution
* systemd for service management
* Deployment on a remote Linux server (EC2)

---

## Features

* CPU, RAM, and Disk usage monitoring
* JSON-based metrics export
* Web dashboard accessible via browser
* Automated execution via cron
* Persistent service using systemd
* SSH-based deployment workflow

---

## Project Structure

```
server-guardian/
├── backend/
│   └── app.py
├── scripts/
│   └── guardian.sh
├── config/
│   └── config.conf
├── logs/
├── requirements.txt
└── README.md
```

---

## Local Setup (Development)

### Create project

```bash
cd ~/repos/git
mkdir server-guardian
cd server-guardian
git init
git branch -m main
```

### Connect to GitHub

```bash
git remote add origin https://github.com/g-mancini/server-guardian.git
git remote set-url origin git@github.com:g-mancini/server-guardian.git
git remote -v
```

### Initial commit

```bash
touch README.md
git add README.md
git commit -m "Initial commit: project setup"
git push -u origin main
```

---

## Project Structure Setup

```bash
mkdir scripts backend config logs

touch scripts/guardian.sh
touch backend/app.py
touch config/config.conf
touch requirements.txt
```

### Commit structure

```bash
git add .
git commit -m "Add core structure: bash monitoring script + flask dashboard"
git push
```

---

## EC2 Setup

### Connect to instance

```bash
ssh -i your-key.pem ubuntu@YOUR-EC2-IP
```

### Install dependencies

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git python3 python3-pip -y
```

---

## Configure SSH for GitHub (EC2)

```bash
ssh-keygen -t ed25519 -C "ec2-server"
cat ~/.ssh/id_ed25519.pub
```

Add the key to GitHub:
https://github.com/settings/keys

Test:

```bash
ssh -T git@github.com
```

---

## Clone Repository on EC2

```bash
git clone git@github.com:g-mancini/server-guardian.git
cd server-guardian
ls
```

---

## Python Environment Setup

```bash
sudo apt install python3.12-venv -y

python3 -m venv venv
source venv/bin/activate
```

---

## Install Dependencies

```bash
pip install flask
```

Verify:

```bash
python -c "import flask; print(flask.__version__)"
```

---

## Run Dashboard

```bash
python backend/app.py
```

Access from browser:

```
http://YOUR-EC2-IP:5000
```

Make sure port 5000 is open in EC2 Security Groups.

---

## Bash Script Execution

```bash
chmod +x scripts/guardian.sh
sudo ./scripts/guardian.sh
```

Check output:

```bash
cat /var/log/guardian_metrics.json
```

---

## Automation with Cron

```bash
sudo crontab -e
```

Add:

```bash
*/5 * * * * /home/ubuntu/server-guardian/scripts/guardian.sh
```

---

## systemd Service

Create service file:

```bash
sudo nano /etc/systemd/system/server-guardian.service
```

Content:

```ini
[Unit]
Description=Server Guardian Dashboard
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/server-guardian
ExecStart=/home/ubuntu/server-guardian/venv/bin/python backend/app.py
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable server-guardian
sudo systemctl start server-guardian
```

Check status:

```bash
sudo systemctl status server-guardian
```

---

## Debug Commands

```bash
ss -tulnp | grep 5000
curl http://localhost:5000
cat /var/log/server_guardian.log
```

---

## Architecture

* Bash script collects system metrics
* Metrics are saved as JSON in `/var/log`
* Flask reads the JSON file and renders a dashboard
* Cron updates metrics periodically
* systemd keeps the dashboard running

---

## Notes

* The Flask server runs in development mode
* Root privileges are required for system-level logging
* Designed for Debian/Ubuntu environments (e.g. AWS EC2)

---

## Future Improvements

* Add authentication to dashboard
* Integrate real-time charts
* Add alerting (email or messaging)
* Reverse proxy with Nginx
* HTTPS support

---

## License

MIT License

