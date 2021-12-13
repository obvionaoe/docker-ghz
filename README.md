# docker-ghz

[![Docker Pulls](https://img.shields.io/docker/pulls/obvionaoe/ghz.svg)](https://hub.docker.com/r/obvionaoe/ghz/)
[![](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-orange.svg)](https://www.buymeacoffee.com/obvionaoe)

A slim Alpine-based [docker image](https://hub.docker.com/r/obvionaoe/ghz) for running [ghz](https://github.com/bojand/ghz) load tests.

## Usage:

It is highly recommended that you use volume mounts, to mount your proto and config files into the
container before executing your call. This will allow you to call your service with
minimal configuration:

```
docker run \
    --volume "${PWD}/protos:/ghz/protos" \
    --volume "${PWD}/config.json:/ghz/config.json" \
    obvionaoe/ghz \
    --config=/ghz/config.json \
    --proto=/ghz/protos/HelloWorld.proto \
    --call=helloworld.Greeter.SayHello \
    0.0.0.0:50051
```

This will start the ghz load test.

You can show the help message by running:

```
docker run obvionaoe/ghz --help
```

For more information on running ghz, see: https://ghz.sh
