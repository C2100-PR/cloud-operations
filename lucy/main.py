import os
from flask import Flask
from google.cloud import secretmanager
from openai import OpenAI
from anthropic import Anthropic

app = Flask(__name__)

OPENAI_KEY = "sk-your-existing-key"
ANTHROPIC_KEY = "sk-ant-api-key"

@app.route('/')
def home():
    client = OpenAI(api_key=OPENAI_KEY)
    anthropic = Anthropic(api_key=ANTHROPIC_KEY)
    return {'status': 'operational', 'keys': 'configured'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))