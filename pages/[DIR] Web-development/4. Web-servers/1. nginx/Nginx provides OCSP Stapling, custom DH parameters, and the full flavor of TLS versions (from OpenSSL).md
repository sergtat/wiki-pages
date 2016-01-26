# Nginx provides OCSP Stapling, custom DH parameters, and the full flavor of TLS versions (from OpenSSL).
```nginx
server {
    listen 443 ssl;

    # certs sent to the client in SERVER HELLO are concatenated in ssl_certificate
    ssl_certificate /path/to/signed_cert_plus_intermediates;
    ssl_certificate_key /path/to/private_key;
    ssl_session_timeout 5m;
    ssl_session_cache shared:SSL:5m;

    # Diffie-Hellman parameter for DHE ciphersuites, recommended 2048 bits
    ssl_dhparam /path/to/dhparam.pem;

    # Intermediate configuration. tweak to your needs.
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers '<paste intermediate ciphersuite here>';
    ssl_prefer_server_ciphers on;
 
    # Enable this if your want HSTS (recommended)
    # add_header Strict-Transport-Security max-age=15768000;
 
    # OCSP Stapling ---
    # fetch OCSP records from URL in ssl_certificate and cache them
    ssl_stapling on;
    ssl_stapling_verify on;
    ## verify chain of trust of OCSP response using Root CA and Intermediate certs
    ssl_trusted_certificate /path/to/root_CA_cert_plus_intermediates;
    resolver <IP DNS resolver>;
 
    ....
}
```
