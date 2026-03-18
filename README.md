# Server Guardian

Server Guardian is a lightweight server monitoring and automation toolkit built with Bash and Flask.
It collects system metrics, exposes them through a web dashboard, and runs automatically on a remote server (e.g. AWS EC2).

---

## Overview

This project combines:

+ A Bash script for system monitoring and automation
+ A Flask web application for visualization
+ Cron for periodic execution
+ systemd for service management
+ Deployment on a remote Linux server (EC2)

---

## Features

+ CPU, RAM, and Disk usage monitoring
+ JSON-based metrics export
+ Web dashboard accessible via browser
+ Automated execution via cron
+ Persistent service using systemd
+ SSH-based deployment workflow

---

## Architecture

+ Bash script collects system metrics
+ Metrics are saved as JSON in `/var/log`
+ Flask reads the JSON file and renders a dashboard
+ Cron updates metrics periodically
+ systemd keeps the dashboard running


---

## Notes

+ The Flask server runs in development mode
+ Root privileges are required for system-level logging
+ Designed for Debian/Ubuntu environments (e.g. AWS EC2)

---

## Project Structure

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

---

## Python Environment Setup (Ubuntu)
sudo apt install python3.12-venv -y
pip install flask

## Automation with Cron
sudo crontab -e
Add:
*/5 * * * * /home/ubuntu/server-guardian/scripts/guardian.sh

## systemd Service
Create service file:
/etc/systemd/system/server-guardian.service
Content:

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


Enable and start:
sudo systemctl daemon-reload
sudo systemctl enable server-guardian
sudo systemctl start server-guardian

---

## Future Improvements

+ Add authentication to dashboard
+ Integrate real-time charts
+ Add alerting (email or messaging)
+ Reverse proxy with Nginx
+ HTTPS support

---

## License

MIT License

