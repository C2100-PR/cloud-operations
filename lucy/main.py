import os
from flask import Flask
from google.cloud import secretmanager
from openai import OpenAI

app = Flask(__name__)

def get_secret(secret_id):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/api-for-warp-drive/secrets/{secret_id}/versions/latest"
    return client.access_secret_version(request={"name": name}).payload.data.decode()

@app.route('/')
def home():
    openai_key = get_secret('openai-api-key')
    client = OpenAI(api_key=openai_key)
    return {'status': 'operational'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))