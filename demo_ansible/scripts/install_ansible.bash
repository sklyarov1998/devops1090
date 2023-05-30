#!/bin/bash

if [ -x "$(command -v ansible)" ]; then
    echo "Ansible is already installed."
    ansible --version
    exit 0
fi

sudo apt update

sudo apt install -y ansible

sudo apt install sshpass -y

ansible --version

