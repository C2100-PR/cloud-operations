import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({"status": "healthy", "message": "Dr. Lucy is operational"})

@app.route('/health')
def health():
    return jsonify({"status": "UP"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))