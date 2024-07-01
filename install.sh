#!/usr/bin/env bash

# Install Ansible.
if ! command -v ansible &>/dev/null; then
    rpm-ostree install --apply-live ansible
fi

# Install Ansible collection.
collection_dir="$HOME/.ansible/collections/ansible_collections/voler88/workstation"
if [ ! -d "$collection_dir" ]; then
    git clone https://github.com/voler88/workstation-ansible.git "$collection_dir"
fi

# Ran Ansible playbook.
ANSIBLE_LOCALHOST_WARNING=False ansible-playbook voler88.workstation.main
