# Recon Bash Scripts

A collection of Bash scripts for basic reconnaissance tasks in penetration testing.

## Scripts Included

- `subdomain_enum.sh`: Enumerate subdomains using Certificate Transparency and DNS brute force
- `whois_lookup.sh`: Perform WHOIS lookups and extract key information
- `dns_records.sh`: Extract various DNS records (A, AAAA, MX, NS, TXT, etc.)
- `recon.sh`: General recon script that runs all the above scripts

## Usage

Make scripts executable and run:

```bash
chmod +x *.sh
./subdomain_enum.sh example.com
./whois_lookup.sh example.com
./dns_records.sh example.com
./dns_records.sh example.com A  # Specific record type
./recon.sh example.com  # Run all scripts
```

## Requirements

- Bash
- curl
- dig
- whois
- nslookup

## License

MIT