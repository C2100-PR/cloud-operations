FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install flask openai gunicorn
CMD exec gunicorn --bind :$PORT app:app