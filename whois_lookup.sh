#!/bin/bash

# Whois Lookup
# Performs whois lookups and extracts key information

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_FILE="whois_${DOMAIN}.txt"

echo "Retrieving WHOIS information for $DOMAIN"
echo ""

# Perform whois lookup
if command -v whois &> /dev/null; then
    whois "$DOMAIN" > "$OUTPUT_FILE" 2>&1
else
    echo "Error: whois command not found"
    echo "Install with: apt-get install whois (Debian/Ubuntu) or brew install whois (macOS)"
    exit 1
fi

echo "[+] WHOIS lookup complete"
echo "[+] Full results saved to $OUTPUT_FILE"
echo ""
echo "=== Key Information ===="

echo ""
echo "Domain Name:"
grep -i "domain name" "$OUTPUT_FILE" | head -1 || echo "Not found"

echo ""
echo "Registrar:"
grep -i "registrar:" "$OUTPUT_FILE" | head -1 || echo "Not found"

echo ""
echo "Registration Date:"
grep -i "creation date\|registered:" "$OUTPUT_FILE" | head -1 || echo "Not found"

echo ""
echo "Expiration Date:"
grep -i "expiration date\|expire date\|registry expiry" "$OUTPUT_FILE" | head -1 || echo "Not found"

echo ""
echo "Nameservers:"
grep -i "name server\|nameserver" "$OUTPUT_FILE" || echo "Not found"