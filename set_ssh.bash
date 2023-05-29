if [ $# -ne 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> <PASSWORD>"
    exit 1
fi

ip_address=$1
password=$2

# Generate new SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# Copy public key to remote machine using sshpass
sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub "sela@$ip_address"

# Modify sshd_config file to enable public key authentication
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "sudo sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config"

# Reload SSH service
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "sudo systemctl reload ssh"
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "sudo systemctl reload sshd"

# Exit remote machine
sshpass -p "$password" ssh -o StrictHostKeyChecking=no "sela@$ip_address" "exit"

# Run Ansible ping module on host machine
ansible -m ping all


