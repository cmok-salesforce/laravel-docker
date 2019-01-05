  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=FR/ST=PARIS/L=07-EME/O=SALESFORCE/CN=localhost" \
  -keyout "./certificate/key.pem" \
  -out "./certificate/cert.pem" \
  -days 3650 -nodes -sha256