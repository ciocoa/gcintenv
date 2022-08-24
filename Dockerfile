FROM alpine:latest
ENV TZ=Asia/Shanghai \
  GIT_BRANCH=development \
  RESOURCE_VERSION=3.0 \
  WEBDASHBOARD_VERSION=6.1.0 \
  LANGUAGE=zh-CN \
  ENABLE_CONSOLE=false \
  ACCESS_ADDRESS=127.0.0.1 \
  BIND_PORT=443 \
  MONGODB_URL=localhost:27017 
ADD entrypoint.sh /root/entrypoint.sh
RUN cd /root && apk add --no-cache openjdk17-jre openssl \
  && wget https://nightly.link/Grasscutters/Grasscutter/workflows/build/${GIT_BRANCH}/Grasscutter.zip \
  && unzip -q Grasscutter.zip \
  && mv $(find -name "grasscutter*.jar" -type f) grasscutter.jar \
  && wget https://github.com/Koko-boya/Grasscutter_Resources/archive/refs/heads/${RESOURCE_VERSION}.zip -O resources.zip \
  && unzip -q resources.zip \
  && mv Grasscutter_Resources-${RESOURCE_VERSION}/Resources resources \
  && wget https://github.com/liujiaqi7998/GrasscuttersWebDashboard/releases/download/V${WEBDASHBOARD_VERSION}/GrasscuttersWebDashboard-${WEBDASHBOARD_VERSION}.jar \
  && mkdir plugins \
  && mv $(find -name "GrasscuttersWebDashboard*.jar" -type f) plugins/webDashboard.jar \
  && rm -rf Grasscutter.zip resources.zip Grasscutter_Resources-${RESOURCE_VERSION} \
  && apk del openssl \
  && cat entrypoint.sh && ls -la
EXPOSE 80 443 22102/udp
VOLUME [ "/root" ]
WORKDIR /root
CMD [ "sh","entrypoint.sh" ]
