#!/bin/bash

# Master deployment script for 2100.cool infrastructure
# This single script handles everything

# Configuration
PROJECT_ID="api-for-warp-drive"
REGION="us-central1"
DOMAINS=("staging.2100.cool" "2100.cool")

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting 2100.cool Deployment${NC}"

# 1. Set up SSL certificates
for domain in "${DOMAINS[@]}"; do
    cert_name="${domain//./-}-cert"
    echo -e "\n${YELLOW}Setting up SSL for $domain${NC}"
    
    gcloud compute ssl-certificates create $cert_name \
        --domains=$domain \
        --global \
        --project=$PROJECT_ID || \
    echo "Certificate exists"
done

# 2. Deploy Cloud Run services
for domain in "${DOMAINS[@]}"; do
    env="${domain//.2100.cool/}"
    [ "$env" == "$domain" ] && env="production"
    
    echo -e "\n${YELLOW}Deploying $env environment${NC}"
    
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
done

# 3. Set up monitoring
echo -e "\n${YELLOW}Configuring monitoring${NC}"

# Create uptime checks
for domain in "${DOMAINS[@]}"; do
    gcloud monitoring uptime-check-configs create "${domain//./-}-uptime" \
        --display-name="$domain Uptime" \
        --http-check-path="/health" \
        --ports=443 \
        --hostname="$domain" || echo "Uptime check exists"
done

# Create alert policy
gcloud alpha monitoring policies create \
    --display-name="2100.cool Alerts" \
    --conditions="metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" threshold=500" \
    --notification-channels="projects/$PROJECT_ID/notificationChannels/15208165367670947355,projects/$PROJECT_ID/notificationChannels/17736180891900909331" \
    --documentation="Production and staging alerts for 2100.cool"

# 4. Verify deployment
echo -e "\n${YELLOW}Verifying deployment${NC}"

for domain in "${DOMAINS[@]}"; do
    echo "Checking $domain..."
    curl -s -o /dev/null -w "%{http_code}" https://$domain/_health
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $domain deployed successfully${NC}"
    else
        echo -e "${RED}✗ $domain deployment issue${NC}"
    fi
done

echo -e "\n${GREEN}Deployment Complete!${NC}"
