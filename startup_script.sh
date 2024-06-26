#!/bin/bash
# personal_website startup script

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm use 22.3.0

set -e
set -x

echo "Started startup script at: $(date)"

sudo apt-get update || true
sudo apt-get upgrade || true
sudo apt autoremove || true
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
nvm install node

cd $HOME/webhook
pm2 start redeploy.js || true
cd $HOME/personal_website/api
pm2 stop api || true
pm2 start "yarn start" --name "api" || true

echo "Finished startup script at: $(date)"
