# infrastructure
General Home Infrastructure

Managing python requirements using pipenv as otherwise it's a pain managing multiple python requirements:
```bash
sudo apt install pipenv
pipenv install -r requirements.txt
pipenv shell
```

For the moment I've added the host IP's to the admin machines `/etc/hosts` file that ansible then uses to resolve hosts.
