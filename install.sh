#!/usr/bin/env bash

# Install Ansible.
if ! command -v ansible &>/dev/null; then
    rpm-ostree install --apply-live ansible
fi

# Install Ansible collections.
# TODO

# Ran Ansible playbooks.
# TODO
