#!/bin/bash

set -ex

# TODO: switch all/infra/optional

for SERVICE in proxy portainer monitoring scale loki sentry; do
    pushd "$SERVICE"
    docker stack deploy - c docker-compose.staging.yml --resolve-image=always "$SERVICE"
    popd
done
