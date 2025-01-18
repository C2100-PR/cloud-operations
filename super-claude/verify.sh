#!/bin/bash

# Verification script for Super Claude deployment
PROJECT_ID="api-for-warp-drive"
DOMAIN="2100.cool"

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "${YELLOW}Super Claude Deployment Verification${NC}"
log "======================================="

# 1. SSL Certificate
log "\n${YELLOW}1. SSL Certificate Status:${NC}"
gcloud compute ssl-certificates describe sc2100cool --global

# 2. Cloud Run Service
log "\n${YELLOW}2. Cloud Run Service Status:${NC}"
gcloud run services list --platform managed --region=us-west4

# 3. Load Balancer
log "\n${YELLOW}3. Load Balancer Configuration:${NC}"
gcloud compute forwarding-rules list

# 4. Domain Verification
log "\n${YELLOW}4. Domain Health Check:${NC}"
curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/_health

# 5. Monitoring
log "\n${YELLOW}5. Monitoring Status:${NC}"
gcloud monitoring uptime-check-configs list

log "\n${GREEN}Verification Complete!${NC}"
