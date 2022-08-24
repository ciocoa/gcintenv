#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")
key="/root/keystore.p12"
config="/root/config.json"
accessAddress=${ACCESS_ADDRESS}
language=${LANGUAGE}
bindPort=${BIND_PORT}
enableConsole=${ENABLE_CONSOLE}
connectionUri=${MONGODB_URL}

cd /root

if [ ! -f "$key" ]; then

echo "💠 [$time] 生成证书 💠"

mkdir certs && cd certs

openssl req -x509 -nodes -days 25202 -newkey rsa:2048 -subj "/C=GB/ST=Essex/L=London/O=Grasscutters/OU=Grasscutters/CN=$accessAddress" -keyout CAkey.key -out CAcert.crt

openssl genpkey -out ssl.key -algorithm rsa

cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = GB
ST = Essex
L = London
O = Grasscutters
OU = Grasscutters
CN = $accessAddress

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = $accessAddress

EOF

openssl req -new -key ssl.key -out ssl.csr -config csr.conf

cat > cert.conf <<EOF
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, keyAgreement, dataEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = $accessAddress

EOF

openssl x509 -req -in ssl.csr -CA CAcert.crt -CAkey CAkey.key -CAcreateserial -out ssl.crt -days 25202 -sha256 -extfile cert.conf

openssl pkcs12 -export -out keystore.p12 -inkey ssl.key -in ssl.crt -certfile CAcert.crt -passout pass:123456

cd ..

mv certs/keystore.p12 .

rm -rf certs

fi

if [ ! -f "$config" ]; then

echo "💠 [$time] 初始化配置 💠"

java -jar grasscutter.jar

sed -i 's#"language": "en_US"#"language": "$language"#g' config.json

sed -i 's#"accessAddress": "127.0.0.1"#"accessAddress": "$accessAddress"#g' config.json

sed -i 's#"bindPort": 443#"bindPort": $bindPort#g' config.json

sed -i 's#"enableConsole": true#"enableConsole": $enableConsole#g' config.json

sed -i 's#"connectionUri": "mongodb://localhost:27017"#"connectionUri": "$connectionUri"#g' config.json

fi

echo "💠 [$time] 运行服务器 💠"

java -jar grasscutter.jar
