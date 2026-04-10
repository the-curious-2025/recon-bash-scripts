#!/bin/bash

# DNS Records Extraction
# Extracts and displays DNS records for a domain

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <domain> [record_type]"
    echo "Record types: A, AAAA, CNAME, MX, NS, TXT, SOA, or ALL (default)"
    exit 1
fi

DOMAIN=$1
RECORD_TYPE=${2:-ALL}
OUTPUT_FILE="dns_records_${DOMAIN}.txt"

echo "Extracting DNS records for $DOMAIN"
echo ""

if ! command -v dig &> /dev/null; then
    echo "Error: dig command not found"
    echo "Install with: apt-get install dnsutils (Debian/Ubuntu) or brew install bind (macOS)"
    exit 1
fi

# Create output file header
{
    echo "========================"
    echo "DNS Records for: $DOMAIN"
    echo "========================"
    echo "Generated: $(date)"
    echo ""
} > "$OUTPUT_FILE"

# Function to query a record type
query_record() {
    local type=$1
    echo "[*] Querying $type records..."
    echo "" >> "$OUTPUT_FILE"
    echo "=== $type Records ===" >> "$OUTPUT_FILE"
    dig +short "$DOMAIN" "$type" >> "$OUTPUT_FILE" 2>/dev/null || true
    echo "" >> "$OUTPUT_FILE"
}

# Query based on type
case "$RECORD_TYPE" in
    A)
        query_record "A"
        ;;
    AAAA)
        query_record "AAAA"
        ;;
    CNAME)
        query_record "CNAME"
        ;;
    MX)
        query_record "MX"
        ;;
    NS)
        query_record "NS"
        ;;
    TXT)
        query_record "TXT"
        ;;
    SOA)
        query_record "SOA"
        ;;
    ALL)
        query_record "A"
        query_record "AAAA"
        query_record "CNAME"
        query_record "MX"
        query_record "NS"
        query_record "TXT"
        query_record "SOA"
        ;;
    *)
        echo "Unknown record type: $RECORD_TYPE"
        exit 1
        ;;
esac

echo "[+] DNS records extraction complete"
echo "[+] Results saved to $OUTPUT_FILE"
echo ""

# Display results
cat "$OUTPUT_FILE"