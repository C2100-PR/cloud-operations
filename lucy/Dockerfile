# Multi-stage build for security scanning
FROM aquasec/trivy:latest as scanner
WORKDIR /scan
COPY lucy/. .
RUN trivy filesystem --no-progress /

# Production image
FROM python:3.9-slim-buster
WORKDIR /app

# Security updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash appuser

COPY lucy/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY lucy/. .
RUN chown -R appuser:appuser /app

ENV PORT=8080
EXPOSE ${PORT}

USER appuser

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT}/ || exit 1

CMD ["python", "main.py"]