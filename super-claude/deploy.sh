#!/bin/bash

# Master deployment script for Super Claude infrastructure
PROJECT_ID="api-for-warp-drive"
REGIONS=("us-west4" "us-west1")
DOMAIN="2100.cool"

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "${YELLOW}Starting Super Claude deployment...${NC}"

# 1. Verify existing SSL certificate
log "${YELLOW}Verifying SSL certificate...${NC}"
gcloud compute ssl-certificates describe sc2100cool --global || {
    log "${RED}SSL certificate not found${NC}"
    exit 1
}

# 2. Clean up unnecessary load balancers
log "${YELLOW}Cleaning up old configurations...${NC}"
gcloud compute forwarding-rules list --format="get(name)" | \
grep -v "anthology" | while read -r rule; do
    if [ ! -z "$rule" ]; then
        gcloud compute forwarding-rules delete "$rule" --quiet --global
    fi
done

# 3. Configure us-west4 deployment
log "${YELLOW}Configuring us-west4 deployment...${NC}"

# Deploy Cloud Run service
gcloud run deploy super-claude-west4 \
    --image=gcr.io/$PROJECT_ID/super-claude:latest \
    --platform=managed \
    --region=us-west4 \
    --memory=4Gi \
    --cpu=2 \
    --min-instances=2 \
    --max-instances=10 \
    --port=8080 \
    --allow-unauthenticated

# 4. Update load balancer configuration
log "${YELLOW}Updating load balancer configuration...${NC}"

# Update existing proxy
gcloud compute target-https-proxies update anthology-https-proxy \
    --ssl-certificates=sc2100cool \
    --global

# 5. Configure monitoring
log "${YELLOW}Setting up monitoring...${NC}"

# Create uptime check
gcloud monitoring uptime-check-configs create super-claude-health \
    --display-name="Super Claude Health Check" \
    --http-check-path="/_health" \
    --ports=443 \
    --hostname="$DOMAIN"

# Create alert policy
gcloud alpha monitoring policies create \
    --display-name="Super Claude Performance" \
    --conditions="metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" threshold=500" \
    --notification-channels="projects/$PROJECT_ID/notificationChannels/15208165367670947355,projects/$PROJECT_ID/notificationChannels/17736180891900909331"

# 6. Final verification
log "${YELLOW}Running final verification...${NC}"

log "Cloud Run Services:"
gcloud run services list --platform managed --region=us-west4

log "\nSSL Certificates:"
gcloud compute ssl-certificates list

log "\nLoad Balancer Configuration:"
gcloud compute forwarding-rules list

log "${GREEN}Deployment complete!${NC}"
