#!/bin/bash

# Phase 1: Infrastructure Cleanup
PROJECT_ID="api-for-warp-drive"

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "${YELLOW}Starting Phase 1: Infrastructure Cleanup${NC}"

# 1. List current state
log "\n${YELLOW}Current Infrastructure State:${NC}"
gcloud compute forwarding-rules list
gcloud compute ssl-certificates list
gcloud compute target-https-proxies list

# 2. Clean unused forwarding rules
log "\n${YELLOW}Cleaning unused forwarding rules...${NC}"
gcloud compute forwarding-rules list --format="get(name)" | \
grep -v "anthology-lb-rule" | while read -r rule; do
    if [ ! -z "$rule" ]; then
        log "Removing rule: $rule"
        gcloud compute forwarding-rules delete "$rule" --quiet --global 2>/dev/null || \
        gcloud compute forwarding-rules delete "$rule" --quiet --region=us-west4 2>/dev/null || \
        gcloud compute forwarding-rules delete "$rule" --quiet --region=us-west1 2>/dev/null
    fi
done

# 3. Verify anthology-https-proxy
log "\n${YELLOW}Verifying anthology-https-proxy configuration...${NC}"
gcloud compute target-https-proxies describe anthology-https-proxy --global

# 4. Verify SSL certificate
log "\n${YELLOW}Verifying SSL certificate...${NC}"
gcloud compute ssl-certificates describe sc2100cool --global

# 5. Final state verification
log "\n${YELLOW}Final Infrastructure State:${NC}"
log "\nForwarding Rules:"
gcloud compute forwarding-rules list

log "\nSSL Certificates:"
gcloud compute ssl-certificates list

log "\nHTTPS Proxies:"
gcloud compute target-https-proxies list

log "${GREEN}Phase 1 Complete!${NC}"
