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
ADD . /root
RUN cd /root && sh docker-setup.sh
EXPOSE 80 443 22102/udp
VOLUME [ "/root" ]
ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
