#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 <domain> [-o output_file]"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

DOMAIN="$1"
shift || true
OUTPUT_FILE="whois_${DOMAIN}.txt"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

if ! command -v whois >/dev/null 2>&1; then
  echo "Error: whois command not found"
  echo "Install with: apt-get install whois (Debian/Ubuntu) or brew install whois (macOS)"
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "Retrieving WHOIS information for $DOMAIN"
whois "$DOMAIN" > "$OUTPUT_FILE" 2>&1

echo "[+] WHOIS lookup complete"
echo "[+] Full results saved to $OUTPUT_FILE"
echo
echo "=== Key Information ==="
echo

echo "Domain Name:"
grep -iE "domain name" "$OUTPUT_FILE" | head -1 || echo "Not found"
echo
echo "Registrar:"
grep -iE "registrar:" "$OUTPUT_FILE" | head -1 || echo "Not found"
echo
echo "Registration Date:"
grep -iE "creation date|registered:" "$OUTPUT_FILE" | head -1 || echo "Not found"
echo
echo "Expiration Date:"
grep -iE "expiration date|expire date|registry expiry" "$OUTPUT_FILE" | head -1 || echo "Not found"
echo
echo "Nameservers:"
grep -iE "name server|nameserver" "$OUTPUT_FILE" || echo "Not found"
