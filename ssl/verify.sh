#!/bin/bash

# SSL Verification Script
PROJECT_ID="api-for-warp-drive"

# Check certificate status
echo "Checking SSL certificates..."
gcloud compute ssl-certificates list \
    --project=$PROJECT_ID \
    --filter="name~2100-cool"

# Check proxy configurations
echo "\nChecking HTTPS proxy configurations..."
gcloud compute target-https-proxies list \
    --project=$PROJECT_ID

# Verify domains
echo "\nVerifying domain configurations..."
for domain in "2100.cool" "staging.2100.cool"; do
    echo "\nChecking $domain..."
    curl -I https://$domain
done