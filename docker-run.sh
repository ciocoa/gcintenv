#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

cd /tmp

echo "💠 [ $time ] 初始化依赖... 💠"

apk add --no-cache openjdk18-jre openssl tzdata

cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "💠 [ $time ] 初始化依赖...Done. 💠"

echo "💠 [ $time ] 拉取服务端... 💠"

wget https://nightly.link/Grasscutters/Grasscutter/workflows/build/development/Grasscutter.zip

unzip -q Grasscutter.zip

mv $(find -name "grasscutter*.jar" -type f) /root/grasscutter.jar

echo "💠 [ $time ] 拉取服务端...Done. 💠"

echo "💠 [ $time ] 拉取资源... 💠"

wget https://github.com/Koko-boya/Grasscutter_Resources/archive/refs/heads/3.0.zip -O resources.zip

unzip -q resources.zip

mv Grasscutter_Resources-3.0/Resources /root/resources

echo "💠 [ $time ] 拉取资源...Done. 💠"

echo "💠 [ $time ] 清理文件... 💠"

mv docker-entrypoint.sh /root

cd /root

rm -rf /tmp/*

apk del tzdata

echo "💠 [ $time ] 清理文件...Done. 💠"
