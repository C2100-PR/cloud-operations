FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install flask openai gunicorn
ENV OPENAI_API_KEY=your_key_here
CMD exec gunicorn --bind :$PORT app:app