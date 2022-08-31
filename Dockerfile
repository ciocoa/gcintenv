FROM alpine:latest
ENV TZ=Asia/Shanghai \
  GC_BRANCH=development \
  GC_RESOURCE=3.0 \
  GC_WEB_PLUGIN=false \
  GC_LANGUAGE=en_US \
  GC_ENABLE_CONSOLE=true \
  GC_ACCESS_ADDRESS=127.0.0.1 \
  GC_BIND_PORT=443 \
  GC_MONGODB_URL=localhost:27017 
COPY *.sh /app/
RUN sh /app/docker-setup.sh
EXPOSE 80 443 22102/udp
VOLUME [ "/root/plugins" ]
ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
