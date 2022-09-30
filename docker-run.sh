#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$time] Initialize dependencies..."

cd /tmp

apk -U --no-cache add openjdk17-jre openssl

echo "[$time] Initialize dependencies...Done."

echo "[$time] Pull the Grasscutter server..."

wget https://nightly.link/Grasscutters/Grasscutter/workflows/build/development/Grasscutter.zip

unzip -q Grasscutter.zip

mv $(find -name "grasscutter*.jar" -type f) /root/grasscutter.jar

echo "[$time] Pull the Grasscutter server...Done."

echo "[$time] Pull the Grasscutter resources..."

wget https://github.com/tamilpp25/Grasscutter_Resources/archive/refs/heads/3.1.zip -O resources.zip

unzip -q resources.zip

mv Grasscutter_Resources-3.1/Resources /root/resources

echo "[$time] Pull the Grasscutter resources...Done."

echo "[$time] Clean up redundant files..."

mv docker-entrypoint.sh /root

rm -rf *

ls -la /root

echo "[$time] Clean up redundant files...Done."
