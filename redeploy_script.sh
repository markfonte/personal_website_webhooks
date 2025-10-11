#!/bin/bash
# personal_website redeploy script

set -Eeuo pipefail
set -e
set -x

usage() {
	echo "Usage: $0 start"
}

start() {
	echo "------------------------------------------------------------------------------"
	echo "Started redeploy script at: $(date)"
	cd ../personal_website
	git restore .
	git pull
	echo "Pulled"
	cd api
	pm2 stop api || true	# May not already be running
	rm package-lock.json || true
	npm install --legacy-peer-deps
	echo "Successful api install"
	pm2 start "npm run start" --name "api"
	echo "Restarted api"
	cd ../client
	rm package-lock.json || true
	npm install --legacy-peer-deps
	echo "Successful client install"
	npm run build
	echo "Finished redeploy script at: $(date)"
}

if [[ $# -ne 1 ]]; then
	usage
	exit 1
fi

case $1 in
	"start")
	start
	;;

	*)
	usage
	exit 1
	;;
esac
