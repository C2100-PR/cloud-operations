FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENV PORT=8080
EXPOSE ${PORT}
CMD exec gunicorn --bind :${PORT} --workers 1 --threads 8 --timeout 0 main:app