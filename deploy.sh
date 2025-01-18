#!/bin/bash

# Master deployment script for 2100.cool infrastructure
PROJECT_ID="api-for-warp-drive"
REGION="us-central1"
DOMAINS=("staging.2100.cool" "2100.cool")

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to log with timestamp
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check command status
check_status() {
    if [ $? -eq 0 ]; then
        log "${GREEN}✓ $1 successful${NC}"
    else
        log "${RED}✗ $1 failed${NC}"
        exit 1
    fi
}

log "${YELLOW}Starting 2100.cool Infrastructure Deployment${NC}"
log "=================================================="

# Phase 1: SSL Certificates
log "\n${YELLOW}Phase 1: SSL Certificate Setup${NC}"
for domain in "${DOMAINS[@]}"; do
    cert_name="${domain//./-}-cert"
    log "Creating certificate for $domain..."
    
    gcloud compute ssl-certificates create $cert_name \
        --domains=$domain \
        --global \
        --project=$PROJECT_ID || \
    log "${YELLOW}Certificate $cert_name already exists${NC}"
    
    # Verify certificate
    gcloud compute ssl-certificates describe $cert_name \
        --global \
        --project=$PROJECT_ID
    check_status "SSL certificate for $domain"
done

# Phase 2: Cloud Run Deployment
log "\n${YELLOW}Phase 2: Service Deployment${NC}"
for domain in "${DOMAINS[@]}"; do
    env="${domain//.2100.cool/}"
    [ "$env" == "$domain" ] && env="production"
    
    log "Deploying $env environment..."
    gcloud run deploy "super-claude-$env" \
        --image="gcr.io/$PROJECT_ID/super-claude:$env" \
        --platform=managed \
        --region=$REGION \
        --memory=2Gi \
        --cpu=1 \
        --min-instances=2 \
        --max-instances=10 \
        --set-env-vars="ENVIRONMENT=$env" \
        --allow-unauthenticated
    check_status "$env deployment"
done

# Phase 3: Monitoring Setup
log "\n${YELLOW}Phase 3: Monitoring Configuration${NC}"

# Setting up uptime checks
for domain in "${DOMAINS[@]}"; do
    log "Creating uptime check for $domain..."
    gcloud monitoring uptime-check-configs create "${domain//./-}-uptime" \
        --display-name="$domain Uptime" \
        --http-check-path="/health" \
        --ports=443 \
        --hostname="$domain" || \
    log "${YELLOW}Uptime check for $domain already exists${NC}"
done

# Creating alert policy
log "Setting up alert policy..."
gcloud alpha monitoring policies create \
    --display-name="2100.cool Alerts" \
    --conditions="metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" threshold=500" \
    --notification-channels="projects/$PROJECT_ID/notificationChannels/15208165367670947355,projects/$PROJECT_ID/notificationChannels/17736180891900909331" \
    --documentation="Production and staging alerts for 2100.cool"
check_status "Alert policy creation"

# Phase 4: Verification
log "\n${YELLOW}Phase 4: Deployment Verification${NC}"

for domain in "${DOMAINS[@]}"; do
    log "Verifying $domain..."
    status_code=$(curl -s -o /dev/null -w "%{http_code}" https://$domain/_health)
    if [ "$status_code" = "200" ]; then
        log "${GREEN}✓ $domain is operational (Status: $status_code)${NC}"
    else
        log "${RED}✗ $domain check failed (Status: $status_code)${NC}"
    fi
done

log "\n${GREEN}Deployment Complete!${NC}"
log "=================================================="

# Final Status Report
log "\nFinal Status:"
log "-------------"
gcloud run services list --platform managed --region=$REGION
log "\nSSL Certificates:"
gcloud compute ssl-certificates list --filter="name~2100-cool"