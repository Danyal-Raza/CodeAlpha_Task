# 🚨 Network Intrusion Detection with Suricata

This repository contains example files to help you get started with **Suricata**, an open-source Network Intrusion Detection System (NIDS), along with a **Bash script** to automatically block suspicious IP addresses based on Suricata alerts.

## 📁 Repository Contents

- `local.rules` — Custom Suricata rule file for detecting suspicious network activity (e.g., HTTP traffic).
- `block_intruders.sh` — A Bash script that monitors Suricata alerts and automatically blocks malicious IP addresses using `iptables`.

---

## 🛠️ Prerequisites

Before using these files, make sure you have:

- A **Linux system** (Ubuntu/Debian recommended)
- **Suricata** installed
- Root privileges (for modifying firewall rules using `iptables`)

---

## 📌 Step-by-Step Usage

### 🔹 1. Install Suricata

```bash
sudo apt update
sudo apt install suricata -y
````

### 🔹 2. Add the Custom Rule

1. Copy the `local.rules` file into your Suricata rules directory:

   ```bash
   sudo cp local.rules /etc/suricata/rules/local.rules
   ```

2. Edit the Suricata config to include the rule file:
   Open `/etc/suricata/suricata.yaml` and ensure it includes:

   ```yaml
   rule-files:
     - local.rules
   ```

---

### 🔹 3. Start Suricata

Start Suricata on your network interface (replace `eth0` with your actual interface):

```bash
sudo suricata -c /etc/suricata/suricata.yaml -i eth0
```

Or start the service:

```bash
sudo systemctl start suricata
```

Alerts will be saved in:

```
/var/log/suricata/fast.log
```

---

### 🔹 4. Run the Bash Script

1. Make the script executable:

   ```bash
   chmod +x block_intruders.sh
   ```

2. Run the script with root privileges:

   ```bash
   sudo ./block_intruders.sh
   ```

✅ This script will continuously monitor Suricata alerts in real time. If a line matches the rule (e.g., `"Possible HTTP connection"`), it will extract the offending IP and block it using `iptables`.

---

## 🔐 Example Use Case

The rule in `local.rules` looks for **any TCP connection to port 80 (HTTP)** and raises an alert:

```text
alert tcp any any -> any 80 (msg:"Possible HTTP connection"; sid:1000004; rev:1;)
```

Once triggered, the bash script automatically:

* Reads the alert log
* Extracts the source IP address
* Adds a firewall rule to block the IP

---

## ⚠️ Important Notes

* Run both Suricata and the script as **root** to allow access to logs and firewall.
* This is a **basic example** to demonstrate functionality. For production use, extend this with:

  * Logging
  * IP whitelist
  * Email/SMS notifications
  * Integration with `fail2ban`, `firewalld`, or a SIEM

---

## 🤝 Contributions & Learning

This project is part of my learning journey during a cybersecurity internship. If you're getting started with Suricata or network defense, feel free to fork, try, and contribute!

If you find this useful, please ⭐ the repository and share your feedback!

---

## 📬 Contact

Connect with me on [https://www.linkedin.com/in/your-profile](https://www.linkedin.com/in/syed-danyal-raza-b80271264/) or open an issue if you have any questions or suggestions!
