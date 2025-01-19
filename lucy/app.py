from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return 'Dr Lucy OK'

app.run(host='0.0.0.0', port=8080)