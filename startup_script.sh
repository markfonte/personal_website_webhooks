#!/bin/bash
# personal_website startup script

set -e
set -x

echo "Started startup script at: $(date)"

pm2 start redeploy.js || true
cd $HOME/personal_website/api
pm2 stop api || true
pm2 start "yarn start" --name "api" || true

echo "Finished startup script at: $(date)"
