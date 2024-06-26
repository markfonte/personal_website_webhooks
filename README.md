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
```sh
crontab -e

...

@reboot sh $HOME/webhook/startup_script.sh >> $HOME/webhook/output.log 2>&1
```
