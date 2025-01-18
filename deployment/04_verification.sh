#!/bin/bash
# Final Verification

echo "✅ Running Final Verification"

# Check services
gcloud run services list --platform managed --region=us-central1

# Check SSL
gcloud compute ssl-certificates list --filter="name~2100-cool"

# Check uptime
gcloud monitoring uptime-check-configs list

# Test endpoints
curl -s -o /dev/null -w "%{http_code}" https://staging.2100.cool/_health
curl -s -o /dev/null -w "%{http_code}" https://2100.cool/_health