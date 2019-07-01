#!/bin/bash
# personal_website redeploy script

set -Eeuo pipefail
set -e
set -x

usage() {
	echo "Usage: $0 start"
}

start() {
	cd ../personal_website
	git pull
	cd api
	npm install
	pm2 restart www
	cd ../client
	npm install
	npm run build
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
