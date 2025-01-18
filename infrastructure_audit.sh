#!/bin/bash

PROJECT_ID="api-for-warp-drive"

echo "========== US-WEST1 (Oregon) =========="
echo "\nGKE Clusters:"
gcloud container clusters list --project=$PROJECT_ID --filter="location:us-west1*"

echo "\nCompute Instances:"
gcloud compute instances list --project=$PROJECT_ID --filter="zone:us-west1*"

echo "\nCloud Run Services:"
gcloud run services list --project=$PROJECT_ID --region=us-west1

echo "\nVPN Tunnels:"
gcloud compute vpn-tunnels list --project=$PROJECT_ID --filter="region:us-west1"

echo "\n========== US-WEST4 (Las Vegas) =========="
echo "\nCompute Instances (RAYS):"
gcloud compute instances list --project=$PROJECT_ID --filter="zone:us-west4*"

echo "\nCloud Run Services:"
gcloud run services list --project=$PROJECT_ID --region=us-west4

echo "\n========== NETWORKING =========="
echo "\nVPC Networks:"
gcloud compute networks list --project=$PROJECT_ID

echo "\nFirewall Rules:"
gcloud compute firewall-rules list --project=$PROJECT_ID

echo "\nLoad Balancers:"
gcloud compute forwarding-rules list --project=$PROJECT_ID

echo "\n========== SSL & DOMAINS =========="
echo "\nSSL Certificates:"
gcloud compute ssl-certificates list --project=$PROJECT_ID

echo "\nDomain Mappings:"
gcloud compute target-https-proxies list --project=$PROJECT_ID