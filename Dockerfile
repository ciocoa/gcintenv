FROM alpine:latest
ENV \
  GC_PLUGIN=false \
  GC_LANGUAGE=en_US \
  GC_ENABLE_CONSOLE=true \
  GC_ACCESS_ADDRESS=127.0.0.1 \
  GC_BIND_PORT=443 \
  GC_MONGODB_URL=localhost:27017 
COPY docker*.sh /tmp/
RUN sh /tmp/docker-run.sh
EXPOSE 80 443 22102/udp
VOLUME [ "/root/plugins" ]
ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
