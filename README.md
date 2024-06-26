## Usage

### Run Redeploy Script
```sh
./redeploy_script.sh start
./redeploy_script.sh usage
```

### Keep Redeploy Script Alive
```sh
pm2 start redeploy.js
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
