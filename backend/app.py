import json
import os
from flask import Flask, render_template_string

app = Flask(__name__)

METRICS_FILE = "/var/log/guardian_metrics.json"

TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Server Guardian</title>
</head>
<body>
    <h1>🛡️ Server Guardian</h1>

    <p><b>CPU:</b> {{cpu}}%</p>
    <p><b>RAM:</b> {{ram}}%</p>
    <p><b>Disk:</b> {{disk}}%</p>
    <p><b>Last update:</b> {{time}}</p>

</body>
</html>
"""

def load_metrics():
    if not os.path.exists(METRICS_FILE):
        return {
            "cpu": 0,
            "ram": 0,
            "disk": 0,
            "timestamp": "N/A"
        }

    with open(METRICS_FILE) as f:
        return json.load(f)

@app.route("/")
def dashboard():
    data = load_metrics()

    return render_template_string(
        TEMPLATE,
        cpu=data["cpu"],
        ram=data["ram"],
        disk=data["disk"],
        time=data["timestamp"]
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
