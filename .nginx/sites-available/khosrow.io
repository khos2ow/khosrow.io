# Redirect all HTTP trafix to HTTPS
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name www.khosrow.io;

    ssl_certificate      /etc/letsencrypt/live/khosrow.io/fullchain.pem;
    ssl_certificate_key  /etc/letsencrypt/live/khosrow.io/privkey.pem;

    return 301 https://khosrow.io$request_uri;
}

# HTTPS configuration
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name khosrow.io;

    access_log /var/log/nginx/khosrow.io/access.log;
    error_log /var/log/nginx/khosrow.io/error.log;

    ssl_certificate      /etc/letsencrypt/live/khosrow.io/fullchain.pem;
    ssl_certificate_key  /etc/letsencrypt/live/khosrow.io/privkey.pem;

    # Improve HTTPS performance with session resumption
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 5m;

    # Enable server-side protection against BEAST attacks
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5;

    # Disable SSLv3
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    # Diffie-Hellman parameter for DHE ciphersuites
    # $ sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
    # ssl_dhparam /etc/ssl/certs/dhparam.pem;

    # Enable HSTS (https://developer.mozilla.org/en-US/docs/Security/HTTP_Strict_Transport_Security)
    # add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";  

    # Enable OCSP stapling (http://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox)
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/letsencrypt/live/khosrow.io/fullchain.pem;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    # Note: You should disable gzip for SSL traffic.
    # See: https://bugs.debian.org/773332

    # Add index.php to the list if you are using PHP
    index index.html;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ =404;
        root /srv/nginx/khosrow.io/public;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    location ~ /\.ht {
        deny all;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /srv/nginx/khosrow.io/public;
        internal;
    }
}
