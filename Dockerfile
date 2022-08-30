FROM alpine:latest
ENV TZ=Asia/Shanghai \
  GIT_BRANCH=development \
  RESOURCE_VER=3.0 \
  ADD_WEB_PLUGIN=false \
  LANGUAGE=en_US \
  ENABLE_CONSOLE=true \
  ACCESS_ADDRESS=127.0.0.1 \
  BIND_PORT=443 \
  MONGODB_URL=localhost:27017 
COPY . /app
RUN sh /app/docker-setup.sh
EXPOSE 80 443 22102/udp
VOLUME [ "/root/plugins" ]
ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
