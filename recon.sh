#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 <domain> [output_directory]"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

DOMAIN="$1"
OUTPUT_BASE="${2:-.}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
RECON_DIR="${OUTPUT_BASE%/}/recon_${DOMAIN}_${TIMESTAMP}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$RECON_DIR"

run_step() {
  local title="$1"
  shift
  echo "$title"
  if "$@"; then
    echo "[OK] $title"
  else
    echo "[WARN] $title failed"
  fi
  echo
}

echo "=========================================="
echo "Starting reconnaissance on ${DOMAIN}"
echo "Output directory: ${RECON_DIR}"
echo "=========================================="
echo

run_step "[1/3] Subdomain Enumeration" \
  bash "$SCRIPT_DIR/subdomain_enum.sh" "$DOMAIN" -o "$RECON_DIR/subdomains_${DOMAIN}.txt"

run_step "[2/3] DNS Records Extraction" \
  bash "$SCRIPT_DIR/dns_records.sh" "$DOMAIN" ALL -o "$RECON_DIR/dns_records_${DOMAIN}.txt"

run_step "[3/3] WHOIS Lookup" \
  bash "$SCRIPT_DIR/whois_lookup.sh" "$DOMAIN" -o "$RECON_DIR/whois_${DOMAIN}.txt"

echo "=========================================="
echo "Reconnaissance complete"
echo "Results saved to: $RECON_DIR"
echo "=========================================="
echo

if command -v ls >/dev/null 2>&1; then
  ls -lh "$RECON_DIR"
fi
