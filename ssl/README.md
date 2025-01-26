# SSL Configuration for 2100.cool

This directory contains SSL certificate configuration and management scripts for both staging.2100.cool and 2100.cool domains.

## Directory Structure
- `config/`: Configuration files for SSL and domain mapping
- `scripts/`: Management and verification scripts
- `monitoring/`: Certificate monitoring and alerting configurations

## Usage
1. Review configurations in `config/`
2. Run setup scripts from `scripts/`
3. Verify configurations using monitoring tools

## Important Notes
- Certificates are managed through GCP Certificate Manager
- Automatic renewal is enabled
- Monitoring alerts are configured for certificate expiration