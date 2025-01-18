#!/bin/bash

# Certificate Monitoring Script
set -euo pipefail

PROJECT_ID="api-for-warp-drive"

# Color coding
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

check_certificate() {
    local cert_name=$1
    
    log "${YELLOW}Checking certificate: $cert_name${NC}"
    
    # Get certificate details
    cert_info=$(gcloud compute ssl-certificates describe $cert_name \
        --global \
        --project=$PROJECT_ID \
        --format=json)
    
    # Extract expiration date
    expiry_date=$(echo $cert_info | jq -r '.expireTime')
    expiry_timestamp=$(date -d "$expiry_date" +%s)
    current_timestamp=$(date +%s)
    
    # Calculate days until expiration
    days_remaining=$(( ($expiry_timestamp - $current_timestamp) / 86400 ))
    
    if [ $days_remaining -lt 30 ]; then
        log "${RED}Warning: Certificate $cert_name expires in $days_remaining days${NC}"
    else
        log "${GREEN}Certificate $cert_name valid for $days_remaining days${NC}"
    fi
}

# Check both certificates
check_certificate "2100-cool-cert"
check_certificate "staging-2100-cool-cert"