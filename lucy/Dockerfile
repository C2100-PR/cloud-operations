FROM python:3.9-slim-buster

WORKDIR /app

# Create non-root user
RUN useradd -m -s /bin/bash appuser

# Install dependencies first for caching
COPY lucy/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY lucy/. .

# Set ownership
RUN chown -R appuser:appuser /app

# Set environment
ENV PORT=8080
EXPOSE ${PORT}

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${PORT}/ || exit 1

CMD ["python", "main.py"]