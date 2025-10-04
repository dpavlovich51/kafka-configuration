# !/bin/bash

echo "Sign the certificate with our own CA"
openssl x509 -req \
  -in "$1/kafka.csr" \
  -CA "$1/ca.crt" -CAkey "$1/ca.key" \
  -CAcreateserial \
  -out "$1/kafka-signed.crt" \
  -days 365 -sha256

echo Import the CA and the signed certificate back into the keystore
keytool -import -trustcacerts -alias CARoot \
  -file "$1/ca.crt" \
  -keystore "$1/kafka.keystore.jks" \
  -storepass "$2" -noprompt

echo "Import the signed certificate into the keystore"
keytool -import -alias kafka \
  -file "$1/kafka-signed.crt" \
  -keystore "$1/kafka.keystore.jks" \
  -storepass "$2"

echo "Create a truststore and import the CA certificate"
keytool -import -trustcacerts -alias CARoot \
  -file "$1/ca.crt" \
  -keystore "$1/kafka.truststore.jks" \
  -storepass "$2" -noprompt

echo "Certificates generated successfully."


