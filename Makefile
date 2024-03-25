include .env
export

venv/bin/python:
	python3 -m venv venv

venv/bin/ansible: venv/bin/python requirements.txt
	venv/bin/pip install -r requirements.txt

ansible: venv/bin/ansible requirements.yaml
	venv/bin/ansible-galaxy install -r requirements.yaml

facts: ansible
	venv/bin/ansible-playbook facts.yaml --diff --become

install: ansible
	venv/bin/ansible-playbook install.yaml --diff --become

check-install: ansible
	venv/bin/ansible-playbook install.yaml --diff --become --check

upgrade: ansible
	venv/bin/ansible-playbook upgrade.yaml --diff --become

check-upgrade: ansible
	venv/bin/ansible-playbook upgrade.yaml --diff --become --check

.PHONY: facts check-install check-upgrade install upgrade
