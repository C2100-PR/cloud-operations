#!/bin/bash

# Live deployment verification script
PROJECT_ID="api-for-warp-drive"
REGION="us-central1"

# Step 1: Check current project
echo "1️⃣ Checking project configuration..."
gcloud config get-value project

# Step 2: Check current SSL certificates
echo "\n2️⃣ Checking existing SSL certificates..."
gcloud compute ssl-certificates list --filter="name~2100-cool"

# Step 3: Check Cloud Run services
echo "\n3️⃣ Checking Cloud Run services..."
gcloud run services list --platform managed --region=$REGION

# Step 4: Check notification channels
echo "\n4️⃣ Checking notification channels..."
gcloud alpha monitoring channels list