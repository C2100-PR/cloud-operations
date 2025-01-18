#!/bin/bash
# Cloud Run Services Setup

echo "🚀 Deploying Cloud Run Services"

# Deploy staging
gcloud run deploy super-claude-staging \
    --image=gcr.io/api-for-warp-drive/super-claude:staging \
    --platform=managed \
    --region=us-central1 \
    --memory=2Gi \
    --set-env-vars="ENVIRONMENT=staging"

# Deploy production
gcloud run deploy super-claude-prod \
    --image=gcr.io/api-for-warp-drive/super-claude:latest \
    --platform=managed \
    --region=us-central1 \
    --memory=4Gi \
    --set-env-vars="ENVIRONMENT=production"