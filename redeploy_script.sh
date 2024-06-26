#!/bin/bash
# personal_website redeploy script

set -Eeuo pipefail
set -e
set -x

usage() {
	echo "Usage: $0 start"
}

start() {
	echo "Starting redeploy script"
	cd ../personal_website
	git restore .
	git pull
	echo "Pulled"
	cd api
	npm install
	echo "Successful api install"
	pm2 restart api || true
	echo "Restarted api"
	cd ../client
	npm install --legacy-peer-deps
	echo "Successful client install"
	npm run build || true
	echo "Finished redeployment"
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
