#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$time] 初始化依赖..."

cd /tmp

apk -U --no-cache add openjdk17-jre openssl

echo "[$time] 初始化依赖...Done."

echo "[$time] 拉取服务端..."

wget https://nightly.link/Grasscutters/Grasscutter/workflows/build/development/Grasscutter.zip

unzip -q Grasscutter.zip

mv $(find -name "grasscutter*.jar" -type f) /root/grasscutter.jar

echo "[$time] 拉取服务端...Done."

echo "[$time] 拉取资源..."

wget https://github.com/tamilpp25/Grasscutter_Resources/archive/refs/heads/3.1.zip -O resources.zip

unzip -q resources.zip

mv Grasscutter_Resources-3.1/Resources /root/resources

echo "[$time] 拉取资源...Done."

echo "[$time] 清理文件..."

mv docker-entrypoint.sh /root

rm -rf *

echo "[$time] 清理文件...Done."
