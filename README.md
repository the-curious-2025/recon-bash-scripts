# Recon Bash Scripts

A collection of shell scripts for automating basic reconnaissance tasks. Includes subdomain enumeration, WHOIS lookups, and DNS record extraction.

## Requirements

- Bash shell
- curl
- dig (dnsutils)
- whois

### Installation

**Debian/Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install curl dnsutils whois
```

**macOS:**
```bash
brew install bind whois curl
```

**RHEL/CentOS:**
```bash
sudo yum install bind-utils whois curl
```

## Scripts

### 1. subdomain_enum.sh
Enumerates subdomains using multiple methods:
- Certificate Transparency logs (crt.sh)
- Common subdomain brute force
- Reverse DNS queries

Usage:
```bash
./subdomain_enum.sh example.com
```

Output: `subdomains_example.com.txt`

### 2. dns_records.sh
Extracts DNS records for a domain.

Usage:
```bash
./dns_records.sh example.com          # All record types
./dns_records.sh example.com A        # A records only
./dns_records.sh example.com MX       # MX records only
```

Supported record types: A, AAAA, CNAME, MX, NS, TXT, SOA, ALL

Output: `dns_records_example.com.txt`

### 3. whois_lookup.sh
Performs WHOIS lookup and extracts key information.

Usage:
```bash
./whois_lookup.sh example.com
```

Extracts:
- Domain name
- Registrar
- Registration date
- Expiration date
- Nameservers
- Registrant contact

Output: `whois_example.com.txt`

### 4. recon.sh (Master Script)
Runs all reconnaissance scripts on a target domain and organizes results.

Usage:
```bash
./recon.sh example.com
```

Creates a timestamped directory with all results:
```
recon_example.com_20260410_120000/
├── subdomains_example.com.txt
├── dns_records_example.com.txt
└── whois_example.com.txt
```

## Setup

1. Clone or download the scripts
2. Make them executable:
   ```bash
   chmod +x *.sh
   ```
3. Run individual scripts or use the master script

## Example

```bash
./recon.sh google.com

# Output:
# ==========================================
# Starting full reconnaissance on google.com
# ==========================================
# 
# [1/3] Subdomain Enumeration...
# [2/3] DNS Records Extraction...
# [3/3] WHOIS Lookup...
# 
# ==========================================
# Reconnaissance complete!
# Results saved to: recon_google.com_20260410_120000
# ==========================================
```

## Use Cases

- Security testing and penetration testing (with proper authorization)
- Domain reconnaissance
- Subdomain discovery
- DNS enumeration
- WHOIS information gathering

## Legal Notice

Use these scripts responsibly and only on domains you own or have explicit permission to test. Unauthorized access to computer systems is illegal.

## Notes

- Some ISPs or networks may block dig/DNS queries - adjust queries accordingly
- WHOIS results vary by registrar
- Certificate Transparency logs may not include all subdomains
- Common subdomain brute force uses a limited list (can be expanded)