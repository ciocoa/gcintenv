#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

cd /app

echo "💠 [ $time ] 初始化依赖... 💠"

apk add --no-cache openjdk17-jre openssl

echo "💠 [ $time ] 初始化依赖...Done. 💠"

echo "💠 [ $time ] 拉取服务端... 💠"

wget https://nightly.link/Grasscutters/Grasscutter/workflows/build/${BRANCH}/Grasscutter.zip

unzip -q Grasscutter.zip

mv $(find -name "grasscutter*.jar" -type f) /root/grasscutter.jar

echo "💠 [ $time ] 拉取服务端...Done. 💠"

echo "💠 [ $time ] 拉取资源... 💠"

wget https://github.com/Koko-boya/Grasscutter_Resources/archive/refs/heads/${RESOURCE}.zip -O resources.zip

unzip -q resources.zip

mv Grasscutter_Resources-${RESOURCE}/Resources /root/resources

echo "💠 [ $time ] 拉取资源...Done. 💠"

echo "💠 [ $time ] 拉取插件... 💠"

wget $(wget -qO- -t1 -T2 "https://api.github.com/repos/liujiaqi7998/GrasscuttersWebDashboard/releases/latest" | grep "browser_download_url" | head -n 1 | awk -F ": " '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')

mkdir /root/plugins

mv $(find -name "GrasscuttersWebDashboard*.jar" -type f) /root/plugins/webDashboard.jar

echo "💠 [ $time ] 拉取插件...Done. 💠"

echo "💠 [ $time ] 清理文件... 💠"

mv docker-entrypoint.sh /root

cd /root

rm -rf /app

ls -la

echo "💠 [ $time ] 清理文件...Done. 💠"
