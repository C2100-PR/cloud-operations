from flask import Flask, jsonify
from openai import OpenAI

app = Flask(__name__)
client = OpenAI()

@app.route('/')
def home():
    try:
        return jsonify({
            'status': 'operational',
            'admin': 'PR@COACHING2100.COM',
            'model': 'gpt-4'
        })
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)