#!/bin/bash

cat <<EOF
Welcome to the marvambass/apache2-ssl-secure container

If you want to add your own VirtualHosts Configuration, you can copy the following SSL Configuration Stuff

	SSLEngine On

	# Locate Certificate File
	SSLCertificateFile /app/certificate/cert.pem
	# Locate Private Key File
	SSLCertificateKeyFile /app/certificate/key.pem

	# CA File
	SSLCACertificateFile /app/certificate/example_ca.crt
	# If you need to add a Intermediate Cert File
	SSLCertificateChainFile /app/certificate/example-intermediate.crt

	# disable old SSL Versions
	SSLProtocol all -SSLv2 -SSLv3

	# disable ssl compression
	SSLCompression Off

	# set HSTS Header
	#Header add Strict-Transport-Security "max-age=31536000" # just this domain
	#Header add Strict-Transport-Security "max-age=31536000; includeSubdomains" # with subdomains

	# Ciphers
	SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4

	SSLHonorCipherOrder on

#############

EOF

if [ ! -z ${HSTS_HEADERS_ENABLE+x} ]
then
  echo ">> HSTS Headers enabled"
  sed -i 's/#Header add Strict-Transport-Security/Header add Strict-Transport-Security/g' /etc/apache2/sites-enabled/001-default-ssl

  if [ ! -z ${HSTS_HEADERS_ENABLE_NO_SUBDOMAINS+x} ]
  then
    echo ">> HSTS Headers configured without includeSubdomains"
    sed -i 's/; includeSubdomains//g' /etc/apache2/sites-enabled/001-default-ssl
  fi
else
  echo ">> HSTS Headers disabled"
fi

# /C=Country
# /ST=State/Province
# /L=Locality
# /O=Organisation
# /CN=Common Name
if [ ! -e "/app/certificate/cert.pem" ] || [ ! -e "/app/certificate/key.pem" ]
then
  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=FR/ST=PARIS/L=07-EME/O=SALESFORCE/CN=localhost" \
  -keyout "/app/certificate/key.pem" \
  -out "/app/certificate/cert.pem" \
  -days 3650 -nodes -sha256
fi

#echo ">> copy /app/certificate/*.conf files to /etc/apache2/sites-enabled/"
#cp /app/certificate/*.conf /etc/apache2/sites-enabled/ 2> /dev/null > /dev/null

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"