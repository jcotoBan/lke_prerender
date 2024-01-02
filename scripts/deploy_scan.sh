#!/bin/bash

curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner"
chmod +x ./sysdig-cli-scanner
SECURE_API_TOKEN=sysdig_api ./sysdig-cli-scanner --apiurl https://us2.app.sysdig.com koton00beng/prerender:main
