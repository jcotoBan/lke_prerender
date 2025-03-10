#!/bin/bash

curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
chmod +x ./sysdig-cli-scanner
docker pull almalinux:8
#SECURE_API_TOKEN=$sysdig_api ./sysdig-cli-scanner --apiurl $sysdig_api_url --policy coto_log4j --console-log 992382711296.dkr.ecr.us-east-1.amazonaws.com/prerender:main
SECURE_API_TOKEN=$sysdig_api ./sysdig-cli-scanner --apiurl $sysdig_api_url --policy coto_log4j --console-log almalinux:8