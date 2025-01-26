#!/bin/bash

# SSL Configuration Script
PROJECT_ID="api-for-warp-drive"

# Configure SSL certificates
echo "Setting up SSL certificates..."

# Production certificate
gcloud compute ssl-certificates create 2100-cool-cert \
    --domains=2100.cool \
    --global \
    --project=$PROJECT_ID

# Staging certificate
gcloud compute ssl-certificates create staging-2100-cool-cert \
    --domains=staging.2100.cool \
    --global \
    --project=$PROJECT_ID

# Update load balancer configurations
echo "Updating load balancer configurations..."

# Production proxy
gcloud compute target-https-proxies update prod-https-proxy \
    --ssl-certificates=2100-cool-cert \
    --global \
    --project=$PROJECT_ID

# Staging proxy
gcloud compute target-https-proxies update staging-https-proxy \
    --ssl-certificates=staging-2100-cool-cert \
    --global \
    --project=$PROJECT_ID

echo "SSL configuration complete!"