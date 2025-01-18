#!/bin/bash

PROJECT_ID="api-for-warp-drive"

echo "========== NETWORK CONNECTIVITY AUDIT =========="

# VPC Network Configuration
echo "\nVPC Peering Connections:"
gcloud compute networks peerings list --project=$PROJECT_ID

# VPN Tunnel Status
echo "\nVPN Tunnel Status:"
gcloud compute vpn-tunnels list --project=$PROJECT_ID

# Routes
echo "\nNetwork Routes:"
gcloud compute routes list --project=$PROJECT_ID

# Firewall Rules
echo "\nRelevant Firewall Rules:"
gcloud compute firewall-rules list --project=$PROJECT_ID \
    --filter="network:default OR network~.*gke.*"

# Load Balancer Health
echo "\nLoad Balancer Backend Health:"
gcloud compute backend-services get-health anthology-backend \
    --global --project=$PROJECT_ID || echo "No backend service found"

# Verify Network Endpoints
echo "\nNetwork Endpoints:"
gcloud compute network-endpoint-groups list \
    --project=$PROJECT_ID --filter="region:(us-west1 OR us-west4)"