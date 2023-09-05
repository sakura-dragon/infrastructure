# infrastructure
General Home Infrastructure

Managing python requirements using pipenv as otherwise it's a pain managing multiple python requirements:
```bash
sudo apt install python3-venv
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

For the moment I've added the host IP's to the admin machines `/etc/hosts` file that ansible then uses to resolve hosts.
