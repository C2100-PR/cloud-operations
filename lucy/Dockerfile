FROM python:3.9-slim
WORKDIR /app
COPY app app/
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENVIRONMENT PORT=8080
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app.main:app