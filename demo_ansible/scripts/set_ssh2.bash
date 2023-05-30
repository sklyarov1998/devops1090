#!/bin/bash

# Check if file argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <FILE>"
    exit 1
fi

file=$1

# Check if file exists
if [ ! -f "$file" ]; then
    echo "File not found: $file"
    exit 1
fi
sudo apt install sshpass -y
# Read file line by line
while IFS=',' read -r ip_address password; do
    echo "Configuring SSH for $ip_address"

    # Generate new SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

    # Copy public key to remote machine using sshpass
sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub "sela@$ip_address"

    # Modify sshd_config file to enable public key authentication
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config"

    # Insert public key into authorized_keys file
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo $(cat ~/.ssh/id_rsa.pub) >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

    # Reload SSH service
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "sudo service ssh restart"
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "sudo systemctl reload sshd"

    # Exit remote machine
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "exit"

done < "$file"

# Run Ansible ping module on host machine
ansible -m ping all

