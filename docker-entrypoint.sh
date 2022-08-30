#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

cd /root

if [ ${WEB_PLUGIN} ] && [ ! -f "/root/plugins/*.jar" ]; then

echo "💠 [ $time ] 拉取插件... 💠"

wget $(wget -qO- -t1 -T2 "https://api.github.com/repos/liujiaqi7998/GrasscuttersWebDashboard/releases/latest" | grep "browser_download_url" | head -n 1 | awk -F ": " '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')

mkdir plugins

mv $(find -name "GrasscuttersWebDashboard*.jar" -type f) plugins/webDashboard.jar

echo "💠 [ $time ] 拉取插件...Done. 💠"

fi

if [ ! -f "/root/keystore.p12" ]; then

echo "💠 [ $time ] 生成证书... 💠"

mkdir certs 

cd certs

openssl req -x509 -nodes -days 25202 -newkey rsa:2048 -subj "/C=GB/ST=Essex/L=London/O=Grasscutters/OU=Grasscutters/CN=${ACCESS_ADDRESS}" -keyout CAkey.key -out CAcert.crt

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
CN = ${ACCESS_ADDRESS}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
IP.1 = ${ACCESS_ADDRESS}

EOF

openssl req -new -key ssl.key -out ssl.csr -config csr.conf

cat > cert.conf <<EOF
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, keyAgreement, dataEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = ${ACCESS_ADDRESS}

EOF

openssl x509 -req -in ssl.csr -CA CAcert.crt -CAkey CAkey.key -CAcreateserial -out ssl.crt -days 25202 -sha256 -extfile cert.conf

openssl pkcs12 -export -out keystore.p12 -inkey ssl.key -in ssl.crt -certfile CAcert.crt -passout pass:123456

cd ..

mv certs/keystore.p12 .

rm -rf certs

ls -la

echo "💠 [ $time ] 生成证书...Done. 💠"

fi

if [ ! -f "/root/config.json" ]; then

echo "💠 [ $time ] 初始化配置... 💠"

java -jar grasscutter.jar

sed -i 's#\("language": "\).*#\1'"${LANGUAGE}"'",#g' config.json

sed -i 's#\("accessAddress": "\).*#\1'"${ACCESS_ADDRESS}"'",#g' config.json

sed -i 's#\("bindPort": \)443#\1'${BIND_PORT}'#g' config.json

sed -i 's#\("enableConsole": \).*#\1'${ENABLE_CONSOLE}',#g' config.json

sed -i 's#\("connectionUri": "\).*#\1'"${MONGODB_URL}"'",#g' config.json

echo "💠 [ $time ] 初始化配置...Done. 💠"

fi

echo "💠 [ $time ] 运行服务器... 💠"

java -jar grasscutter.jar
