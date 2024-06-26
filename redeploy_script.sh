#!/bin/bash
# personal_website redeploy script

set -Eeuo pipefail
set -e
set -x

usage() {
	echo "Usage: $0 start"
}

start() {
	echo "Started redeploy script at: $(date)"
	curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
	cd ../personal_website
	git restore .
	git pull
	echo "Pulled"
	cd api
	pm2 stop api || true	# May not already be running
	yarn install
	echo "Successful api install"
	pm2 start yarn --name "api" -- start
	echo "Restarted api"
	cd ../client
	yarn install
	echo "Successful client install"
	yarn build
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
