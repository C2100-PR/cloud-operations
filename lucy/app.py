import os
from flask import Flask
app = Flask(__name__)

@app.route('/', methods=['GET'])
def home():
    return 'Dr Lucy OK'

if __name__ == '__main__':
    port = int(os.getenv('PORT', '8080'))
    app.run(host='0.0.0.0', port=port)