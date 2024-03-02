include .env
export

venv/bin/python:
	python3 -m venv venv

venv/bin/ansible: venv/bin/python requirements.txt
	venv/bin/pip install -r requirements.txt

ansible/ansible_collections: venv/bin/ansible requirements.yaml ansible/roles
	venv/bin/ansible-galaxy install -r requirements.yaml

facts: ansible/ansible_collections
	venv/bin/ansible-playbook facts.yaml --diff --become

install: ansible/ansible_collections
	venv/bin/ansible-playbook install.yaml --diff --become

check: ansible/ansible_collections
	venv/bin/ansible-playbook install.yaml --diff --become --check

update: ansible/ansible_collections
	venv/bin/ansible-playbook update.yaml --diff --become

upgrade: ansible/ansible_collections
	venv/bin/ansible-playbook upgrade.yaml --diff --become

.PHONY: facts check install update upgrade
