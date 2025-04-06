#!/bin/bash

curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
chmod +x ./sysdig-cli-scanner
SECURE_API_TOKEN=$sysdig_api ./sysdig-cli-scanner --apiurl $sysdig_api_url --policy john_policy --console-log 992382711296.dkr.ecr.us-east-1.amazonaws.com/prerender:main