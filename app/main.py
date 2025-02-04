from flask import Flask, request, jsonify
from dotenv import load_dotenv
import mysql.connector, os


# take the environments variables
load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")


def connection():
    # this function creates a database connection and return a object of connection.
    mydb = mysql.connector.connect(
        host= DB_HOST,  
        user= DB_USER,  
        password= DB_PASS,  
        database= DB_NAME  
    )

    return mydb


def execute_querys(db, mode: int, query: str):
    # This function creates a cursor, execute the query and return a value.
    cursor = db.cursor() 
    cursor.execute(query)

    if mode == 1:
        query_result = cursor.fetchall()

    else:
        db.commit()
        return True
    
    cursor.close()
    db.close()

    return query_result


app = Flask(__name__)


# This endpoint is to List users
@app.route("/", methods = ['GET'])
def list():

    try:
        db = connection()
        if not db.is_connected():
            return jsonify({
                "msg": "not found database"
            }), 500
        

        query: str = "SELECT * FROM client"

        result = execute_querys(db, 1, query)

        return jsonify({
            "success": True,
            "msg": result
        }), 200
        
    except:
        return jsonify({
            "success": False,
            "msg": "not found database"
        }), 500

        
# This endpoint is to add users
@app.route("/add", methods = ['POST'])
def add_some_user():

    try:
        body = request.json

        db = connection()
        if not db.is_connected():
            return jsonify({
                "msg": "not found database"
            }), 500
    
        query: str = f"INSERT INTO client (`name`, `email`, `password`) VALUES ('{body['name']}', '{body['email']}', '{body['password']}');"

        result = execute_querys(db, 2, query)

        return jsonify({
            "success": True,
        }), 200

    except KeyError as err:
        return jsonify({
            "success": False,
            "details": "This endpoint needs of a Json body",
            "message": str(err),
        }), 400