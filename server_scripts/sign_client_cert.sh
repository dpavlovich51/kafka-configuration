#!/bin/bash
# Check if path parameter is provided
# $1 - path to server CA 
# $2 - path to a client certificate 
if [ -z "$2" ] || [ -z "$1" ]; then
    echo "error: path parameters are missing"
    exit 1
fi
# Sign the client CSR with the CA certificate and private key
openssl x509 -req -in "$2/client.csr.pem" -CA "$1/ca.crt" -CAkey "$1/ca.key" \
  -CAcreateserial -out "$2/client.cert.pem" -days 365 -sha256

echo "Client certificate signed and saved to $2/client.cert.pem"
