#!/bin/bash

# $1 - path to store certs
# $2 - password for keystore/truststore

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <path> <password>"
    exit 1
fi

echo "📁 сreate folder to store the certificates, keystore and truststore"
mkdir -p "$1"

echo "🔑 generate CA private key"
openssl genrsa -out "$1/ca.key" 2048

# ca.crt - public key. It can be shared with any client or server that needs to verify a certificate signed by this CA
echo "🧾 generate CA certificate (public key)"
openssl req -x509 -new -key "$1/ca.key" -sha256 -days 365 \
  -out "$1/ca.crt" \
  -subj "/CN=MyLocalCA/OU=Dev/O=MyCompany/L=Nicosia/ST=Cyprus/C=CY" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

echo "🧰 create a keystore with a keypair (public and private keys)"
keytool -genkeypair \
  -alias kafka \
  -keyalg RSA \
  -keysize 2048 \
  -keystore "$1/kafka.keystore.jks" \
  -validity 365 \
  -storepass "$2" \
  -keypass "$2" \
  -dname "CN=localhost, OU=Dev, O=MyCompany, L=Nicosia, S=Cyprus, C=CY" \
  -ext "SAN=DNS:localhost,IP:127.0.0.1"

echo "📜 generate the certificate signing request (CSR) from the keystore"
keytool -keystore "$1/kafka.keystore.jks" \
  -alias kafka \
  -certreq \
  -file "$1/kafka.csr" \
  -storepass "$2"

echo "🔒 Saving key credentials..."
echo "$2" > "$1/key-creds"

echo "✅ Done! CA, keystore, and CSR are ready."