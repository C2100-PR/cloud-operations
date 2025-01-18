#!/bin/bash

# Configuration
PROJECT_ID="api-for-warp-drive"
REGION="us-central1"

# Color coding
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Deploying Services and Monitoring${NC}"

# 1. Deploy Cloud Run Services
echo -e "\n${YELLOW}1. Deploying Cloud Run Services${NC}"

# Staging Service
echo "Deploying staging environment..."
gcloud run deploy super-claude-staging \
    --image=gcr.io/$PROJECT_ID/super-claude:staging \
    --platform=managed \
    --region=$REGION \
    --memory=2Gi \
    --cpu=1 \
    --min-instances=2 \
    --max-instances=10 \
    --set-env-vars="ENVIRONMENT=staging" \
    --allow-unauthenticated

# Production Service
echo "\nDeploying production environment..."
gcloud run deploy super-claude-prod \
    --image=gcr.io/$PROJECT_ID/super-claude:latest \
    --platform=managed \
    --region=$REGION \
    --memory=4Gi \
    --cpu=2 \
    --min-instances=3 \
    --max-instances=20 \
    --set-env-vars="ENVIRONMENT=production" \
    --allow-unauthenticated

# 2. Set up Monitoring
echo -e "\n${YELLOW}2. Configuring Monitoring${NC}"

# Uptime checks
echo "Creating uptime checks..."
gcloud monitoring uptime-check-configs create staging-uptime \
    --display-name="staging.2100.cool Uptime" \
    --http-check-path="/health" \
    --ports=443 \
    --hostname="staging.2100.cool"

gcloud monitoring uptime-check-configs create prod-uptime \
    --display-name="2100.cool Uptime" \
    --http-check-path="/health" \
    --ports=443 \
    --hostname="2100.cool"

# Alert policy
echo "Setting up alert policy..."
gcloud alpha monitoring policies create \
    --display-name="2100.cool Service Alerts" \
    --conditions="metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" threshold=500" \
    --notification-channels="projects/$PROJECT_ID/notificationChannels/15208165367670947355,projects/$PROJECT_ID/notificationChannels/17736180891900909331" \
    --documentation="Production and staging alerts for 2100.cool"

# 3. Verify Deployment
echo -e "\n${YELLOW}3. Verifying Deployment${NC}"

# Check services
echo "\nCloud Run Services:"
gcloud run services list --platform managed --region=$REGION

# Check uptime configs
echo "\nUptime Checks:"
gcloud monitoring uptime-check-configs list

# Check endpoints
for domain in "staging.2100.cool" "2100.cool"; do
    echo "\nTesting $domain..."
    status_code=$(curl -s -o /dev/null -w "%{http_code}" https://$domain/_health)
    if [ "$status_code" = "200" ]; then
        echo -e "${GREEN}✓ $domain is operational (Status: $status_code)${NC}"
    else
        echo -e "${RED}✗ $domain check failed (Status: $status_code)${NC}"
    fi
done

echo -e "\n${GREEN}Deployment Complete!${NC}"
