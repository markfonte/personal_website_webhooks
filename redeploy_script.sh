#!/bin/bash
# personal_website redeploy script

set -Eeuo pipefail
set -e
set -x

usage() {
	echo "Usage: $0 start"
}

# The daemon is the PM2 installed under Node v22.3.0. /usr/bin/pm2 is 3.5.0 and
# prints a warning before JSON, which breaks the process-list parse below.
pm2_bin() {
	local candidate="$HOME/.nvm/versions/node/v22.3.0/bin/pm2"
	if [[ -x "$candidate" ]]; then
		echo "$candidate"
		return
	fi
	command -v pm2
}

# `pm2 start --name api` inserts a new app on every deploy and leaves the
# previous one stopped. Restarting by name would then launch every copy.
# Keep the newest online api entry and delete the rest.
remove_extra_api_apps() {
	local pm2 ids id
	pm2=$(pm2_bin)
	ids=$("$pm2" jlist | node -e '
		let raw = "";
		process.stdin.setEncoding("utf8");
		process.stdin.on("data", (chunk) => { raw += chunk; });
		process.stdin.on("end", () => {
			const start = raw.indexOf("[");
			if (start === -1) process.exit(1);
			const apps = JSON.parse(raw.slice(start));
			const apis = apps.filter((app) => app.name === "api");
			const online = apis.filter((app) => app.pm2_env.status === "online");
			let keep = null;
			for (const app of online) {
				if (keep === null || app.pm_id > keep) keep = app.pm_id;
			}
			const drop = apis
				.filter((app) => app.pm_id !== keep)
				.map((app) => String(app.pm_id));
			process.stdout.write(drop.join(" "));
		});
	')
	if [[ -n "$ids" ]]; then
		for id in $ids; do
			"$pm2" delete "$id"
		done
	fi
}

start() {
	local pm2
	pm2=$(pm2_bin)
	echo "------------------------------------------------------------------------------"
	echo "Started redeploy script at: $(date)"
	cd ../personal_website
	git restore .
	git pull
	echo "Pulled"
	cd api
	remove_extra_api_apps
	# Stop the one remaining app before install so better-sqlite3 is not
	# loaded while npm rebuilds it. `pm2 restart` reuses that same entry.
	if "$pm2" describe api >/dev/null 2>&1; then
		"$pm2" stop api || true
	fi
	rm package-lock.json || true
	npm install --legacy-peer-deps
	echo "Successful api install"
	if "$pm2" describe api >/dev/null 2>&1; then
		"$pm2" restart api
	else
		"$pm2" start "npm run start" --name "api"
	fi
	"$pm2" save
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
