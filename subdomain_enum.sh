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
OUTPUT_FILE="subdomains_${DOMAIN}.txt"

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

if ! command -v nslookup >/dev/null 2>&1; then
  echo "Error: nslookup command not found"
  exit 1
fi

TMP_CT="$(mktemp)"
TMP_COMMON="$(mktemp)"
TMP_AXFR="$(mktemp)"
trap 'rm -f "$TMP_CT" "$TMP_COMMON" "$TMP_AXFR"' EXIT

echo "Starting subdomain enumeration for $DOMAIN"
echo "Results will be saved to $OUTPUT_FILE"
echo

echo "[*] Querying Certificate Transparency logs..."
if command -v curl >/dev/null 2>&1; then
  curl -s "https://crt.sh/?q=%25.${DOMAIN}&output=json" \
    | grep -oE '"name_value":"[^"]+"' \
    | sed -E 's/"name_value":"//; s/"$//; s/\\n/\n/g' \
    | sed 's/^\*\.//' \
    | grep -E "\.${DOMAIN}$|^${DOMAIN}$" \
    | sort -u > "$TMP_CT" || true
fi

echo "[*] Testing common subdomains..."
COMMON_SUBS=(
  "www" "mail" "ftp" "api" "admin" "dev" "test" "staging"
  "blog" "shop" "ns1" "ns2" "smtp" "webmail" "cpanel"
)

for sub in "${COMMON_SUBS[@]}"; do
  HOST="${sub}.${DOMAIN}"
  if nslookup "$HOST" >/dev/null 2>&1; then
    echo "$HOST" >> "$TMP_COMMON"
  fi
done

echo "[*] Attempting DNS zone transfer checks..."
if command -v dig >/dev/null 2>&1; then
  while IFS= read -r ns; do
    [[ -z "$ns" ]] && continue
    dig @"$ns" axfr "$DOMAIN" +time=2 +tries=1 2>/dev/null \
      | awk '{print $1}' \
      | grep -E "\.${DOMAIN}\\.$|^${DOMAIN}\\.$" \
      | sed 's/\.$//' >> "$TMP_AXFR" || true
  done < <(dig +short ns "$DOMAIN" 2>/dev/null)
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"
cat "$TMP_CT" "$TMP_COMMON" "$TMP_AXFR" 2>/dev/null \
  | sed '/^$/d' \
  | sort -u > "$OUTPUT_FILE"

echo "[+] Enumeration complete"
echo "[+] Found $(wc -l < "$OUTPUT_FILE") potential subdomains"
echo "[+] Results saved to $OUTPUT_FILE"
