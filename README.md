# Recon Bash Scripts

Small Bash toolkit for basic domain reconnaissance.

## Included scripts

- `recon.sh` run the full flow and collect results in one folder
- `subdomain_enum.sh` collect potential subdomains
- `dns_records.sh` query DNS records
- `whois_lookup.sh` fetch WHOIS details

## Requirements

- Bash
- `curl`
- `nslookup`
- `dig`
- `whois`

Debian/Ubuntu setup:

```bash
sudo apt-get update
sudo apt-get install -y curl dnsutils whois
```

## Quick start

```bash
chmod +x *.sh
./recon.sh example.com
```

Expected output directory:

```text
recon_example.com_YYYYMMDD_HHMMSS/
   subdomains_example.com.txt
   dns_records_example.com.txt
   whois_example.com.txt
```

## Run scripts individually

```bash
./subdomain_enum.sh example.com -o out/subdomains.txt
./dns_records.sh example.com MX -o out/dns_mx.txt
./whois_lookup.sh example.com -o out/whois.txt
```

## Common issues

- **`dig` not found**: install `dnsutils` (Linux) or `bind` (macOS).
- **No subdomains found**: target may have limited public footprint.
- **WHOIS output is sparse**: some registrars redact details.

## Responsible use

Use only on domains you own or have explicit authorization to assess.

## License

MIT.