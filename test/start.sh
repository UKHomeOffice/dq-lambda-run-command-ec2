#!/bin/bash

set -e

function create_key {
         mkdir /tmp/.ssh/
         ssh-keygen -t rsa -b 1024 -C "test@test.com" -f /tmp/.ssh/test_ssh_key -q -N ""
         ssh_key=$(cat /tmp/.ssh/test_ssh_key | sed '1 s/^.*$/-----BEGIN RSA PRIVATE KEY-----/' | sed '$ s/^.*$/-----END RSA PRIVATE KEY-----/' | base64)
         echo "Test SSH key created"
}

function sshd {
  run=$(docker run -d -P --rm \
         --name test_sshd \
         rastasheep/ubuntu-sshd:14.04
         )
         docker exec test_sshd passwd -d root
         docker cp /tmp/.ssh/test_ssh_key.pub test_sshd:/root/.ssh/authorized_keys
         docker exec test_sshd chown root:root /root/.ssh/authorized_keys
         echo "Created SSHD container"
}

function python_build {
  run=$(docker build -t python-run-command-ec2 ../.
         )
         echo "Created Python container"
}

function python_run {
         docker run -P --rm --name python-run-command-ec2 \
         -e ip_address="test_sshd" \
         -e ssh_user="root" \
         -e ssh_key="$ssh_key" \
         -e command="uname -a" \
         --link test_sshd:test_sshd \
         python-run-command-ec2
}

function cleanup {
  run=$(docker stop test_sshd && \
        rm -r /tmp/.ssh
        )
        unset ssh_key
}

function main {
  echo "********************************************"
  echo "Create test ssh key"
  create_key || cleanup
  echo "********************************************"
  echo "Start SSHD container..."
  sshd || cleanup
  echo "********************************************"
  echo "Build Python continaer..."
  python_build || cleanup
  echo "********************************************"
  echo "Run Python container..."
  python_run || cleanup
  echo "********************************************"
  echo "Cleanup..."
  cleanup
  echo "********************************************"
  echo "Done!"
}

main

exit
