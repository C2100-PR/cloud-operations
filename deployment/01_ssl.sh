#!/bin/bash
# SSL Certificate Setup

echo "🔐 Setting up SSL Certificates"

# Create staging certificate
gcloud compute ssl-certificates create staging-2100-cool-cert \
    --domains=staging.2100.cool \
    --global

# Create production certificate
gcloud compute ssl-certificates create 2100-cool-cert \
    --domains=2100.cool \
    --global

# Verify certificates
gcloud compute ssl-certificates list --filter="name~2100-cool"