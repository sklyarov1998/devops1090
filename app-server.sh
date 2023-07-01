#!/bin/bash

# Update package manager
sudo apt update

# Install Python and pip
sudo apt install -y python3 python3-pip

# Install psycopg2 and flask using pip
pip3 install psycopg2 flask

# Run the Flask app server
python3 app-server.py
