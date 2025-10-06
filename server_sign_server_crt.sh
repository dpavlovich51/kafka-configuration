# !/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <path> <password>"
  exit 1
fi

echo "🔏 Signing the Kafka CSR with our CA (including SANs)..."

# Create temporary openssl extension file for SANs
extfile="$(mktemp)"
cat > "$extfile" <<EOF
[ v3_req ]
subjectAltName = DNS:localhost,IP:127.0.0.1
EOF

# Sign the CSR using our CA and include SANs
openssl x509 -req \
  -in "$1/kafka.csr" \
  -CA "$1/ca.crt" -CAkey "$1/ca.key" \
  -CAcreateserial \
  -out "$1/kafka-signed.crt" \
  -days 365 -sha256 \
  -extfile "$extfile" -extensions v3_req

# Clean up the temp file
rm -f "$extfile"

echo "🧱 Importing the CA root certificate into keystore..."
keytool -import -trustcacerts -alias CARoot \
  -file "$1/ca.crt" \
  -keystore "$1/kafka.keystore.jks" \
  -storepass "$2" -noprompt

echo "🔗 Importing the signed Kafka certificate into keystore..."
keytool -import -alias kafka \
  -file "$1/kafka-signed.crt" \
  -keystore "$1/kafka.keystore.jks" \
  -storepass "$2" -noprompt

echo "🛡️  Creating truststore and importing CA certificate..."
keytool -import -trustcacerts -alias CARoot \
  -file "$1/ca.crt" \
  -keystore "$1/kafka.truststore.jks" \
  -storepass "$2" -noprompt

echo "Certificates generated successfully."


