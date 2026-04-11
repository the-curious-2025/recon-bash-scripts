# Recon Bash Scripts

Command-line recon toolkit for domain-level information gathering.

## Included Scripts

- `subdomain_enum.sh` subdomain discovery (CT logs + common names + DNS checks)
- `dns_records.sh` DNS record extraction (`A`, `MX`, `TXT`, etc.)
- `whois_lookup.sh` WHOIS export with key summary
- `recon.sh` orchestrator that runs all scripts and stores output in one directory

## Requirements

- Bash
- `curl`
- `nslookup`
- `dig`
- `whois`

Install on Debian/Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y curl dnsutils whois
```

## Quick Start

```bash
chmod +x *.sh
./recon.sh example.com
```

Output folder format:

```text
recon_example.com_YYYYMMDD_HHMMSS/
   subdomains_example.com.txt
   dns_records_example.com.txt
   whois_example.com.txt
```

## Individual Usage

```bash
./subdomain_enum.sh example.com
./subdomain_enum.sh example.com -o out/subdomains.txt

./dns_records.sh example.com
./dns_records.sh example.com MX -o out/dns_mx.txt

./whois_lookup.sh example.com
./whois_lookup.sh example.com -o out/whois.txt
```

## Safety

Use only on domains you own or are explicitly authorized to assess.

## License

MIT (see `LICENSE`).