# Section 133: Apache Web Server Configuration

<details open>
<summary><b>Section 133: Apache Web Server Configuration (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Basic Apache HTTP Configuration](#basic-apache-http-configuration)
- [Configuring SSL for HTTPS](#configuring-ssl-for-https)
- [Virtual Hosting for Multiple Websites](#virtual-hosting-for-multiple-websites)
- [Firewall Configuration and Testing](#firewall-configuration-and-testing)
- [Summary](#summary)

## Overview
This section covers Apache web server configuration, including setting up basic HTTP hosting on port 80, implementing SSL for HTTPS on port 443 using self-signed certificates, and configuring virtual hosting to serve multiple websites from a single server. We'll explore practical examples, firewall rules, and testing access via browsers.

## Basic Apache HTTP Configuration

### Key Concepts
Apache uses the `httpd` service for web serving. Install it via `dnf install httpd`. The default document root is `/var/www/html` where website files are placed.

### Deep Dive
1. Install the package:
   ```
   dnf install httpd
   ```

2. Create a simple HTML file in `/var/www/html/index.html`:
   ```
   <!DOCTYPE html>
   <html>
   <head><title>Welcome</title></head>
   <body><h1>Welcome to Nehru Classes</h1><p>Please Subscribe on YouTube</p></body>
   </html>
   ```

3. Start and enable the service:
   ```
   systemctl start httpd
   systemctl enable httpd
   ```

4. Verify status:
   ```
   systemctl status httpd
   ```

Apache listens on port 80 by default.

### Lab Demo
Access the site via browser using server IP (e.g., `http://192.168.0.143`). The page should load showing the HTML content.

## Configuring SSL for HTTPS

### Key Concepts
HTTPS uses port 443 and requires SSL certificates for encryption. Generate self-signed certificates using OpenSSL for local testing.

### Deep Dive
1. Install OpenSSL:
   ```
   dnf install openssl
   ```

2. Generate certificates (key and certificate):
   ```
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout local.cert.key -out local.cert.crt
   ```
   Fill in prompts (e.g., Country: IN, State: Delhi, etc.).

3. Move files to SSL directories:
   ```
   mv local.cert.crt /etc/pki/tls/certs/
   mv local.cert.key /etc/pki/tls/private/
   ```

4. Edit `/etc/httpd/conf/httpd.conf` to add SSL configuration:
   ```
   <VirtualHost *:443>
       ServerName www.neharaclasses.com
       SSLEngine on
       SSLCertificateFile /etc/pki/tls/certs/local.cert.crt
       SSLCertificateKeyFile /etc/pki/tls/private/local.cert.key
       DocumentRoot /var/www/html
   </VirtualHost>
   ```

5. Check syntax and restart service:
   ```
   httpd -t
   httpd -D DUMP_CONFIG
   systemctl restart httpd
   ```

### Lab Demo
Access via `https://www.neharaclasses.com` (accept self-signed certificate warning).

### Tables
| Protocol | Port | Purpose |
|----------|------|---------|
| HTTP | 80 | Unencrypted web traffic |
| HTTPS | 443 | Encrypted SSL/TLS traffic |

## Virtual Hosting for Multiple Websites

### Key Concepts
Virtual hosting allows serving multiple sites from one server by differentiating based on domain names or IPs.

### Deep Dive
1. Create directories:
   - `/var/www/website1` for first site.
   - `/var/www/website2` for second site.

2. Set ownership:
   ```
   chown apache:apache /var/www/website1
   chown apache:apache /var/www/website2
   ```

3. Add to `httpd.conf`:
   ```
   <VirtualHost *:443>
       ServerName www.neharaclasses.com
       SSLEngine on
       SSLCertificateFile /etc/pki/tls/certs/local.cert.crt
       SSLCertificateKeyFile /etc/pki/tls/private/local.cert.key
       DocumentRoot /var/www/website1
   </VirtualHost>
   
   <VirtualHost *:443>
       ServerName www.jag.net
       SSLEngine on
       SSLCertificateFile /etc/pki/tls/certs/local.cert.crt
       SSLCertificateKeyFile /etc/pki/tls/private/local.cert.key
       DocumentRoot /var/www/website2
   </VirtualHost>
   ```

4. Deploy content (upload HTML/JS files to respective directories).

### Lab Demo
Access each site via their ServerName over HTTPS.

## Firewall Configuration and Testing

### Key Concepts
Configure firewalld to allow HTTP/HTTPS traffic.

### Deep Dive
1. Add services:
   ```
   firewall-cmd --permanent --add-service=http
   firewall-cmd --permanent --add-service=https
   ```

2. Reload firewall:
   ```
   firewall-cmd --reload
   ```

3. Check rules:
   ```
   firewall-cmd --list-all
   ```

### Lab Demo
Test browser access to both virtual hosts over HTTPS.

### Alerts
> [!NOTE]
> Self-signed certificates show warnings in browsers; use CA certificates for production.

## Summary

### Key Takeaways
```diff
+ Apache serves on port 80 (HTTP) and 443 (HTTPS) by default
+ SSL encryption prevents data interception by sniffers
+ Virtual hosting enables multiple sites on one server via domain-based routing
- Self-signed certificates cause browser warnings; use proper CA-signed certs for production
! Always test firewall rules and service status after configuration changes
```

### Quick Reference
- Install: `dnf install httpd openssl`
- Start service: `systemctl start httpd`
- Config file: `/etc/httpd/conf/httpd.conf`
- Ports: HTTP (80), HTTPS (443)
- SSL cert paths: `/etc/pki/tls/certs/` and `/etc/pki/tls/private/`

### Expert Insight
**Real-world Application**: Deploy Apache with virtual hosting for cost-effective multi-tenant web environments, integrating with load balancers for scalability.  
**Expert Path**: Master OpenSSL for certificate management and explore mod_ssl for advanced TLS configurations like HSTS.  
**Common Pitfalls**: Incorrect file permissions (use `chown apache:apache`) block access; firewall misconfigurations prevent traffic flow.

</details>
