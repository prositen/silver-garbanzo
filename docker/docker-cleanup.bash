#!/usr/bin/env bash

# From Docker 1.13 docker prune is available
# docker system prune

# Deletes all exited docker containers and dangling images
docker ps -q -f status=exited | xargs --no-run-if-empty docker rm
docker images --quiet --filter=dangling=true | xargs --no-run-if-empty docker rmi
