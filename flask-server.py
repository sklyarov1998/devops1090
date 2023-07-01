from flask import Flask, render_template, request
import psycopg2
import json

app = Flask(__name__)

def read_config():
    with open('config.json', 'r') as config_file:
        config = json.load(config_file)
    return config

def execute_schema():
    with open('data.sql', 'r') as schema_file:
        schema = schema_file.read()
    
    conn = psycopg2.connect(
        host=config['db_host'],
        port=config['db_port'],
        dbname=config['db_name'],
        user=config['db_user'],
        password=config['db_password']
    )
    cur = conn.cursor()
    cur.execute(schema)
    conn.commit()
    cur.close()
    conn.close()

def insert_data(name, weight_value, time):
    conn = psycopg2.connect(
        host=config['db_host'],
        port=config['db_port'],
        dbname=config['db_name'],
        user=config['db_user'],
        password=config['db_password']
    )
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO data (name, weight_value, time) VALUES (%s, %s, %s)",
        (name, weight_value, time)
    )
    conn.commit()
    cur.close()
    conn.close()

@app.route('/data', methods=['POST'])
def process_data():
    data = request.json
    
    # Accessing the values
    name = data.get('name')
    weight_value = data.get('weight_value')
    time = data.get('time')
    
    # Store the data in the database
    insert_data(name, weight_value, time)
    
    # Return a response
    return "Data received and stored successfully!"

@app.route('/form', methods=['GET', 'POST'])
def show_form():
    if request.method == 'POST':
        name = request.form.get('name')
        weight_value = request.form.get('weight')
        time = request.form.get('time')
        
        # Store the data in the database
        insert_data(name, weight_value, time)
        
        return "Data received and stored successfully!"
    
    return render_template('form.html')

if __name__ == '__main__':
    config = read_config()  # Read database configuration from config.json
    execute_schema()  # Create table using data.sql
    app.run(debug=True)
