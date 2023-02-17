.PHONY: all lint clean setup-* dev
.NOTPARALLEL: setup-*
.DEFAULT_GOAL: all
SYSTEM_PYTHON := /usr/bin/python3
VAULT_PASSWORD := .vault-password.txt

export ANSIBLE_LIBRARY=.ansible/modules
export ANSIBLE_COLLECTIONS_PATH=.ansible/collections
export ANSIBLE_ROLES_PATH=.ansible/roles

all: setup-all

dev: venv/bin/python3 venv/bin/ansible-playbook secrets.enc
	$< -m pip install ansible-lint ansible-navigator

setup-%: playbooks/%-playbook.yml venv/bin/ansible-playbook secrets.enc .ansible
	venv/bin/ansible-playbook --connection local --inventory 127.0.0.1, --limit 127.0.0.1 \
		-e "ansible_python_interpreter=${SYSTEM_PYTHON}" \
		$<

lint: venv/bin/pre-commit .git
	$< run -a

clean:
	-rm -rf venv .ansible

.ansible: requirements.yml
	venv/bin/ansible-galaxy install -r $<


.git:
	git init .

venv/bin/python3:
	$(SYSTEM_PYTHON) -m venv venv
	$@ -m pip install -U pip

venv/bin/ansible-playbook venv/bin/ansible-vault venv/bin/ansible-galaxy: venv/bin/python3
	$^ -m pip install ansible

venv/bin/pre-commit: venv/bin/python3
	$^ -m pip install pre-commit
	$@ install --install-hooks

secrets.enc: venv/bin/ansible-vault
	$^ encrypt --output $@ secrets
