#!/bin/bash

# Subdomain Enumeration
# Uses multiple methods to enumerate subdomains

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1
OUTPUT_FILE="subdomains_${DOMAIN}.txt"

echo "Starting subdomain enumeration for $DOMAIN"
echo "Results will be saved to $OUTPUT_FILE"
echo ""

# Method 1: Using crt.sh (Certificate Transparency)
echo "[*] Querying Certificate Transparency logs..."
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" 2>/dev/null | grep -oP '(?<=name_value")[^"]*' | sed 's/\*.//g' | sort -u > /tmp/ct_subs.txt 2>/dev/null || true

# Method 2: Using DNS brute force with common subdomains
echo "[*] Testing common subdomains..."
COMMON_SUBS=("www" "mail" "ftp" "localhost" "webmail" "smtp" "pop" "ns1" "webdisk" "ns2" "cpanel" "cPanel" "whm" "autodiscover" "webdisk" "h5.webdisk" "repository")

for sub in "${COMMON_SUBS[@]}"; do
    HOST="$sub.$DOMAIN"
    if nslookup "$HOST" 8.8.8.8 >/dev/null 2>&1; then
        echo "$HOST" >> /tmp/common_subs.txt 2>/dev/null || true
    fi
done

# Method 3: Try to get subdomains from reverse DNS
echo "[*] Attempting reverse DNS lookup..."
if command -v dig &> /dev/null; then
    dig +short ns "$DOMAIN" | while read ns; do
        if [ -n "$ns" ]; then
            dig @"$ns" axfr "$DOMAIN" 2>/dev/null | grep -oP '^[^\s]+' | grep "\.$DOMAIN" >> /tmp/axfr_subs.txt 2>/dev/null || true
        fi
    done
fi

# Combine all results
> "$OUTPUT_FILE"
cat /tmp/ct_subs.txt /tmp/common_subs.txt /tmp/axfr_subs.txt 2>/dev/null | sort -u | grep -v "^$" >> "$OUTPUT_FILE" || true

# Clean up
rm -f /tmp/ct_subs.txt /tmp/common_subs.txt /tmp/axfr_subs.txt

echo "[+] Enumeration complete"
echo "[+] Found $(wc -l < "$OUTPUT_FILE") potential subdomains"
echo "[+] Results saved to $OUTPUT_FILE"