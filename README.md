files in this branch are used to establish flask server and a postgresql db server. the flask server gets a user input and store it in postgresql db. 

use "app-server.sh" script to set the enviroment on the machine running the flask server

use "db-server.sh" script to set the enviroment on the machine running the postgresql db

the "config.json" file is used to store the db-server values to be passed to the "flask-server.py". it's crucial to keep it up-to-date (the current file presents a template) and to store in the same directory as the "flask-server.app". 

"data.sql" file contains quiries to be run in the database to create the table to which the flask-server.app passes the user input. 

