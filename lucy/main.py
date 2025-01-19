import os
from flask import Flask, jsonify
from google.cloud import secretmanager

app = Flask(__name__)

def check_secrets():
    client = secretmanager.SecretManagerServiceClient()
    project = "api-for-warp-drive"
    status = {}
    
    secrets = ["openai-api-key", "anthropic-api-key", "vertex-api-key", "vision-lake-key"]
    for secret in secrets:
        try:
            name = f"projects/{project}/secrets/{secret}/versions/latest"
            client.access_secret_version(request={"name": name})
            status[secret] = "available"
        except Exception as e:
            status[secret] = str(e)
    return status

@app.route('/')
def home():
    status = check_secrets()
    return jsonify(status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))