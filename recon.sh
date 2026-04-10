#!/bin/bash

# Recon Master Script
# Runs all recon scripts on a target domain

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RECON_DIR="recon_${DOMAIN}_${TIMESTAMP}"

mkdir -p "$RECON_DIR"

echo "=========================================="
echo "Starting full reconnaissance on $DOMAIN"
echo "=========================================="
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run subdomain enumeration
echo "[1/3] Subdomain Enumeration..."
if [ -f "$SCRIPT_DIR/subdomain_enum.sh" ]; then
    bash "$SCRIPT_DIR/subdomain_enum.sh" "$DOMAIN"
    mv "subdomains_${DOMAIN}.txt" "$RECON_DIR/" 2>/dev/null || true
else
    echo "Warning: subdomain_enum.sh not found"
fi
echo ""

# Run DNS records extraction
echo "[2/3] DNS Records Extraction..."
if [ -f "$SCRIPT_DIR/dns_records.sh" ]; then
    bash "$SCRIPT_DIR/dns_records.sh" "$DOMAIN" ALL > /dev/null 2>&1 || true
    mv "dns_records_${DOMAIN}.txt" "$RECON_DIR/" 2>/dev/null || true
else
    echo "Warning: dns_records.sh not found"
fi
echo ""

# Run WHOIS lookup
echo "[3/3] WHOIS Lookup..."
if [ -f "$SCRIPT_DIR/whois_lookup.sh" ]; then
    bash "$SCRIPT_DIR/whois_lookup.sh" "$DOMAIN" > "$RECON_DIR/whois_${DOMAIN}.txt" 2>&1 || true
else
    echo "Warning: whois_lookup.sh not found"
fi
echo ""

echo "=========================================="
echo "Reconnaissance complete!"
echo "Results saved to: $RECON_DIR"
echo "=========================================="
echo ""
echo "Files generated:"
ls -lh "$RECON_DIR"