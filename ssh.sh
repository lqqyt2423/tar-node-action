#!/bin/bash

# set -xe

echo "tar-node-action in ssh.sh"

ssh_host=$1

if [ -z "$ssh_host" ]; then
  echo "not set ssh_host"
else
  echo "ssh_host: ${ssh_host}"
  echo "try connect ${ssh_host}"
  ssh ${ssh_host} ls -lht
fi
