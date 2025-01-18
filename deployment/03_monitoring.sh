#!/bin/bash
# Monitoring Setup

echo "📊 Setting up Monitoring"

# Create uptime checks
gcloud monitoring uptime-check-configs create staging-check \
    --display-name="staging.2100.cool Uptime" \
    --http-check-path="/health" \
    --hostname="staging.2100.cool"

gcloud monitoring uptime-check-configs create prod-check \
    --display-name="2100.cool Uptime" \
    --http-check-path="/health" \
    --hostname="2100.cool"

# Verify monitoring
gcloud monitoring uptime-check-configs list