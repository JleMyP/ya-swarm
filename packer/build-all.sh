#!/bin/bash

set -ex

packer build -var-file=variables.json image.json
packer build -var-file=variables.json image-docker.json
packer build -var-file=variables.json image-master.json
