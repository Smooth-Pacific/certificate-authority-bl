#!/bin/bash

# Script to create certificates if not already made

# Create certificate directory
mkdir ./certs
cd ./certs

# Generate root certificates
openssl genrsa -des3 -out root.key 2048
openssl req -x509 -new -config ../configs/root.conf -nodes -key root.key -sha256 -days 365 -out root.crt


# Move and update certificate store
cp ~/certs/root.crt /usr/local/share/ca-certificates/root.crt
update-ca-certificates

echo "Generated root certificates"
# Generate server certificates: 

openssl genrsa -out server.key 2048
openssl req -new -config ../configs/server.conf -key server.key -out server.csr


openssl x509 -req -in server.csr -CA root.crt -CAkey root.key -CAcreateserial -out server.crt -days 365 -sha256

cat server.crt root.crt > server-chain-bundle.cert.pem

echo "Generated server certificates"
# Generate document signing certificates

openssl genrsa -out document.key 2048
openssl req -new -config ../configs/document.conf -key document.key -out document.csr
openssl x509 -req -in document.csr -CA root.crt -CAkey root.key -CAcreateserial -out document.crt -days 365 -sha256

cat document.crt root.crt > document-chain-bundle.cert.pem

echo "Generated document certificates"



