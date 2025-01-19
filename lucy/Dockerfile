FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENV PORT=8080
EXPOSE ${PORT}
CMD exec python main.py