#!/bin/bash

# SSL Setup Script for 2100.cool domains
set -euo pipefail

PROJECT_ID="api-for-warp-drive"
REGION="us-central1"

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

setup_certificate() {
    local domain=$1
    local cert_name=$2
    
    log "${YELLOW}Setting up certificate for $domain${NC}"
    
    # Create or update SSL certificate
    gcloud compute ssl-certificates create $cert_name \
        --domains=$domain \
        --global \
        --project=$PROJECT_ID || \
    log "${YELLOW}Certificate $cert_name already exists${NC}"
}

setup_load_balancer() {
    local domain=$1
    local cert_name=$2
    local proxy_name=$3
    
    log "${YELLOW}Configuring load balancer for $domain${NC}"
    
    # Update HTTPS proxy
    gcloud compute target-https-proxies update $proxy_name \
        --ssl-certificates=$cert_name \
        --global \
        --project=$PROJECT_ID
}

verify_setup() {
    local domain=$1
    
    log "${YELLOW}Verifying setup for $domain${NC}"
    
    # Check HTTPS accessibility
    if curl -k -s -o /dev/null -w "%{http_code}" https://$domain; then
        log "${GREEN}Successfully verified $domain${NC}"
    else
        log "${RED}Failed to verify $domain${NC}"
        return 1
    fi
}

# Main execution
log "Starting SSL configuration..."

# Production setup
setup_certificate "2100.cool" "2100-cool-cert"
setup_load_balancer "2100.cool" "2100-cool-cert" "prod-https-proxy"

# Staging setup
setup_certificate "staging.2100.cool" "staging-2100-cool-cert"
setup_load_balancer "staging.2100.cool" "staging-2100-cool-cert" "staging-https-proxy"

# Verify both domains
verify_setup "2100.cool"
verify_setup "staging.2100.cool"

log "${GREEN}SSL configuration completed successfully!${NC}"