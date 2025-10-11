## Usage
### Setup
```sh
sudo apt install nodejs -y
npm install
```

### Run Redeploy Script
```sh
./redeploy_script.sh start
./redeploy_script.sh usage
```

### Serve Redeploy Script
```sh
node redeploy.js
```

### Keep Redeploy Script Alive
```sh
pm2 start "node redeploy.js" --name redeploy
```

### Adding Startup Script to Reboot
#### Option 1
```sh
pm2 startup     # follow prompts
```

#### Option 2
```sh
crontab -e

...

@reboot sh $HOME/personal_website_webhooks/startup_script.sh >> $HOME/personal_website_webhooks/output.log 2>&1
```
