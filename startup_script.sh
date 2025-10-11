#!/bin/bash
# personal_website startup script

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"


sudo apt-get update || true
sudo apt-get upgrade || true
sudo apt autoremove || true

nvm install --lts
nvm install node

set -e
set -x

echo "Started startup script at: $(date)"

cd $HOME/personal_website_webhook
pm2 restart redeploy.js || true
cd $HOME/personal_website/api
pm2 stop api || true
pm2 start "npm run start" --name "api" || true

echo "Finished startup script at: $(date)"
