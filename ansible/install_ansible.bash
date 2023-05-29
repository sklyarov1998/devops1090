#!/bin/bash

if [ -x "$(command -v ansible)" ]; then
    echo "Ansible is already installed."
    ansible --version
    exit 0
fi

sudo apt update

sudo apt install -y ansible

ansible --version

