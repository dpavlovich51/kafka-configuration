#!/bin/bash

echo "Create folder to store the certificates, keystore and truststore"
mkdir -p "$1"

echo "Generate CA private key"
openssl genrsa -out "$1/ca.key" 2048

echo "Generate CA certificate (public key)"
openssl req -x509 -new -key "$1/ca.key" -days 365 \
  -out "$1/ca.crt" \
  -subj "/CN=MyLocalCA/OU=Dev/O=MyCompany/L=Nicosia/ST=Cyprus/C=CY"

echo "Create a keystore with a keypair (public and private keys)"
keytool -genkeypair \
  -alias kafka \
  -keyalg RSA \
  -keysize 2048 \
  -keystore "$1/kafka.keystore.jks" \
  -validity 365 \
  -storepass "$2" \
  -keypass "$2" \
  -dname "CN=localhost, OU=Dev, O=MyCompany, L=Nicosia, S=Cyprus, C=CY"

echo "Generate the certificate signing request (CSR) from the keystore"
keytool -keystore "$1/kafka.keystore.jks" \
  -alias kafka \
  -certreq \
  -file "$1/kafka.csr" \
  -storepass "$2"

echo "$2" > $1/key-creds