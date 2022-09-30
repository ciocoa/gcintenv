#!/bin/sh -l

time=$(date "+%Y-%m-%d %H:%M:%S")

echo "$time >> Initialize dependencies..."

cd /tmp/

apk -U --no-cache add openjdk17-jre openssl tzdata

echo "$time >> Initialize dependencies...Done."

echo "$time >> Pull the Grasscutter server and resources..."

wget https://nightly.link/ciocoa/gcintenv/workflows/gradle/main/app.zip

unzip -q app.zip

mv *.jar /root/

unzip -q resources.zip -d /root/resources/

ls -la /root/resources/

echo "$time >> Pull the Grasscutter server and resources...Done."

echo "$time >> Clean up redundant files..."

mv docker-entrypoint.sh /root/

rm -rf *

ls -la /root/

echo "$time >> Clean up redundant files...Done."
