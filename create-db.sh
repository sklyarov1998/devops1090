#!/bin/bash

# Prompt for the database name
read -p "Enter the name of the database: " dbname

# Prompt for the username
read -p "Enter the username: " username

# Prompt for the password
read -s -p "Enter the password: " password
echo

# Connect to PostgreSQL as a superuser and create the database
sudo -u postgres psql -c "CREATE DATABASE $dbname;"

# Create a new user and set the password
sudo -u postgres psql -c "CREATE USER $username WITH PASSWORD '$password';"

# Grant all privileges on the database to the user
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $dbname TO $username;"

echo "Database created successfully."

