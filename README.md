# Gcintenv

[![Commit](https://img.shields.io/github/last-commit/ciocoa/gcintenv?logo=github)](https://github.com/ciocoa/gcintenv/commits)
[![Workflow](https://img.shields.io/github/workflow/status/ciocoa/gcintenv/Docker?label=publish&logo=github)](https://github.com/ciocoa/gcintenv/actions?query=workflow%3ADocker)

> Thanks
>
> - [Grasscutter](https://github.com/Grasscutters/Grasscutter)
> - [Resources](https://github.com/tamilpp25/Grasscutter_Resources)
> - [Opencommand](https://github.com/jie65535/gc-opencommand-plugin)

Grasscutter integrated environment

e.g.

```yaml
version: "3.9"
services:
  mongo:
    image: mongo
    restart: always
    ports:
      - 27017:27017
    volumes:
      - ./db:/data/db
      - /etc/localtime:/etc/localtime
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: 123456
  # Uncomment if use mongo-express
  # mongo-express:
  #   depends_on:
  #     - mongo
  #   image: mongo-express
  #   restart: always
  #   ports:
  #     - 8081:8081
  #   environment:
  #     ME_CONFIG_BASICAUTH_USERNAME: admin
  #     ME_CONFIG_BASICAUTH_PASSWORD: 123456
  #     ME_CONFIG_MONGODB_URL: mongodb://root:123456@mongo:27017
  gcintenv:
    depends_on:
      - mongo
    image: ghcr.io/ciocoa/gcintenv
    restart: always
    ports:
      - 80:80
      - 443:443
      - 22102:22102/udp
    volumes:
      - ./plugins:/root/plugins
      - /etc/localtime:/etc/localtime
    environment:
      GC_PLUGIN: "true" # use opencommand plugin
      GC_LANGUAGE: en_US # server language
      GC_ACCESS_ADDRESS: 127.0.0.1 # server access address
      GC_BIND_PORT: 443 # server port
      GC_ENABLE_CONSOLE: "false" # Turn off EOF detected warning
      GC_MONGODB_URL: mongodb://root:123456@mongo:27017 # mongodb URL
```
