#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

cd /root

if [ ${GC_PLUGIN} ] && [ ! -f "/root/plugins/opencommand.jar" ]; then

echo "💠 [ $time ] 拉取插件... 💠"

wget https://github.com/jie65535/gc-opencommand-plugin/releases/download/v1.4.0/opencommand-dev-1.4.0.jar

mv $(find -name "opencommand*.jar" -type f) plugins/opencommand.jar

echo "💠 [ $time ] 拉取插件...Done. 💠"

fi

if [ ! -f "/root/keystore.p12" ]; then

echo "💠 [ $time ] 生成证书... 💠"

mkdir certs 

cd certs

openssl req -x509 -nodes -days 25202 -newkey rsa:2048 -subj "/C=GB/ST=Essex/L=London/O=Grasscutters/OU=Grasscutters/CN=${GC_ACCESS_ADDRESS}" -keyout CAkey.key -out CAcert.crt

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
CN = ${GC_ACCESS_ADDRESS}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = ${GC_ACCESS_ADDRESS}

EOF

openssl req -new -key ssl.key -out ssl.csr -config csr.conf

cat > cert.conf <<EOF
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, keyAgreement, dataEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = ${GC_ACCESS_ADDRESS}

EOF

openssl x509 -req -in ssl.csr -CA CAcert.crt -CAkey CAkey.key -CAcreateserial -out ssl.crt -days 25202 -sha256 -extfile cert.conf

openssl pkcs12 -export -out keystore.p12 -inkey ssl.key -in ssl.crt -certfile CAcert.crt -passout pass:123456

cd ..

mv certs/keystore.p12 .

rm -rf certs

echo "💠 [ $time ] 生成证书...Done. 💠"

fi

if [ ! -f "/root/config.json" ]; then

echo "💠 [ $time ] 初始化配置... 💠"

java -jar grasscutter.jar

sed -i 's#\("language": "\).*#\1'"${GC_LANGUAGE}"'",#g' config.json

sed -i 's#\("accessAddress": "\).*#\1'"${GC_ACCESS_ADDRESS}"'",#g' config.json

sed -i 's#\("bindPort": \)443#\1'${GC_BIND_PORT}'#g' config.json

sed -i 's#\("enableConsole": \).*#\1'${GC_ENABLE_CONSOLE}',#g' config.json

sed -i 's#\("connectionUri": "\).*#\1'"${GC_MONGODB_URL}"'",#g' config.json

echo "💠 [ $time ] 初始化配置...Done. 💠"

fi

echo "💠 [ $time ] 运行服务器... 💠"

java -jar grasscutter.jar
