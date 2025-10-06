#!/bin/bash
# Check if path parameter is provided
if [ -z "$1" ]; then
    echo "error: path parameter is missing"
    exit 1
fi
echo "Create client folder for certificates"
mkdir -p "$1"

# Generate client private key
openssl genrsa -out "$1/client.key.pem" 2048

# Generate client certificate signing request (CSR)
openssl req -new -key "$1/client.key.pem" \
-out "$1/client.csr.pem" \
-subj "/CN=go-client/OU=Dev/O=MyCompany/L=Nicosia/ST=Cyprus/C=CY" \
-addext "subjectAltName=DNS:localhost,IP:127.0.0.1"