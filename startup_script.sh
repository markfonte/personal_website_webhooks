#!/bin/bash
# personal_website startup script

set -Eeuo pipefail
set -e
set -x

echo "Started startup script at: $(date)"

pm2 start redeploy.js
cd $HOME/personal_website/api
pm2 start yarn --name "api" -- start

echo "Finished startup script at: $(date)"