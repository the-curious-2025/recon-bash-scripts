#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 <domain> [record_type] [-o output_file]"
  echo "Record types: A, AAAA, CNAME, MX, NS, TXT, SOA, ALL (default)"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

DOMAIN="$1"
shift

RECORD_TYPE="ALL"
if [[ $# -gt 0 && ! "$1" =~ ^- ]]; then
  RECORD_TYPE="$1"
  shift
fi

OUTPUT_FILE="dns_records_${DOMAIN}.txt"

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

if ! command -v dig >/dev/null 2>&1; then
  echo "Error: dig command not found"
  echo "Install with: apt-get install dnsutils (Debian/Ubuntu) or brew install bind (macOS)"
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"

{
  echo "========================"
  echo "DNS Records for: $DOMAIN"
  echo "========================"
  echo "Generated: $(date)"
  echo
} > "$OUTPUT_FILE"

query_record() {
  local type="$1"
  echo "[*] Querying $type records..."
  {
    echo
    echo "=== $type Records ==="
    dig +short "$DOMAIN" "$type" 2>/dev/null || true
  } >> "$OUTPUT_FILE"
}

case "${RECORD_TYPE^^}" in
  A|AAAA|CNAME|MX|NS|TXT|SOA)
    query_record "${RECORD_TYPE^^}"
    ;;
  ALL)
    for t in A AAAA CNAME MX NS TXT SOA; do
      query_record "$t"
    done
    ;;
  *)
    echo "Unknown record type: $RECORD_TYPE"
    usage
    ;;
esac

echo "[+] DNS records extraction complete"
echo "[+] Results saved to $OUTPUT_FILE"
echo
cat "$OUTPUT_FILE"
