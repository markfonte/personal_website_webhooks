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
	rm api/package-lock.json
	rm client/package-lock.json
	git pull
	cd api
	npm install
	npm audit fix
	pm2 restart www
	cd ../client
	npm install
	npm audit fix
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
