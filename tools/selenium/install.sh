#!/bin/bash

curl -s https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install-docker-ce.sh | sudo bash
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose



