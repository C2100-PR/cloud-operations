import os
from flask import Flask, request, jsonify
from openai import OpenAI

app = Flask(__name__)
client = OpenAI(api_key="sk-your-openai-key")

@app.route('/')
def home():
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "system", "content": "You are Dr. Lucy, a helpful AI assistant."}]
    )
    return jsonify({'status': 'operational', 'model': 'gpt-4'})

@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.json
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "system", "content": "You are Dr. Lucy"}, 
                 {"role": "user", "content": data.get('prompt', '')}]
    )
    return jsonify({'response': response.choices[0].message.content})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))