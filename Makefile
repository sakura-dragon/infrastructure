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

check: ansible
	venv/bin/ansible-playbook install.yaml --diff --become --check

update: ansible
	venv/bin/ansible-playbook update.yaml --diff --become

upgrade: ansible
	venv/bin/ansible-playbook upgrade.yaml --diff --become

.PHONY: facts check install update upgrade
