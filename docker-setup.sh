#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

cd /app

echo "💠 [ $time ] 初始化依赖 💠"

apk add --no-cache openjdk17-jre openssl

echo "💠 [ $time ] 拉取服务端 💠"

wget https://nightly.link/Grasscutters/Grasscutter/workflows/build/${GIT_BRANCH}/Grasscutter.zip

unzip -q Grasscutter.zip

mv $(find -name "grasscutter*.jar" -type f) /root/grasscutter.jar

echo "💠 [ $time ] 拉取资源 💠"

wget https://github.com/Koko-boya/Grasscutter_Resources/archive/refs/heads/${RESOURCE_VER}.zip -O resources.zip

unzip -q resources.zip

mv Grasscutter_Resources-${RESOURCE_VER}/Resources /root/resources

echo "💠 [ $time ] 拉取插件 💠"

wget https://github.com/liujiaqi7998/GrasscuttersWebDashboard/releases/download/V${WEBDASHBOARD_VER}/GrasscuttersWebDashboard-${WEBDASHBOARD_VER}.jar

mkdir /root/plugins

mv $(find -name "GrasscuttersWebDashboard*.jar" -type f) /root/plugins/webDashboard.jar

echo "💠 [ $time ] 清理文件 💠"

mv docker-entrypoint.sh /root

cd /root

rm -rf /app

ls -la
