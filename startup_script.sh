#!/bin/bash
# personal_website startup script

set -e
set -x

# Load nvm and set the node version
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Use the specific node version
nvm use 22.3.0

echo "Started startup script at: $(date)"

pm2 start redeploy.js || true
cd $HOME/personal_website/api
pm2 stop api || true
pm2 start "yarn start" --name "api" || true

echo "Finished startup script at: $(date)"
