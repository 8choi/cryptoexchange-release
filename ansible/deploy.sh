#!/bin/bash

export WORKING_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "working dir is set to: $WORKING_DIR"

ansible-playbook -i hosts.yml playbook.yml
