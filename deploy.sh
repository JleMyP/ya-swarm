#!/bin/bash

set -ex

# TODO: check required environments: domain, email (letsencypt)
# TODO: check required files: ssh keys, portainer pass

pushd packer
./build-all.sh
popd

pushd terraform
terraform apply -auto-approve
popd
