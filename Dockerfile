FROM alpine:latest
ENV TZ=Asia/Shanghai \
  GIT_BRANCH=development \
  RESOURCE_VER=3.0 \
  WEBDASHBOARD_VER=6.2.0 \
  LANGUAGE=zh_CN \
  ENABLE_CONSOLE=false \
  ACCESS_ADDRESS=127.0.0.1 \
  BIND_PORT=443 \
  MONGODB_URL=localhost:27017 
ADD . /app
RUN sh /app/docker-setup.sh
EXPOSE 80 443 22102/udp
VOLUME [ "/root/config.json","/root/plugins" ]
ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
