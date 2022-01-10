#!/bin/sh

watch_certs () {
	while true; do
		inotifywait \
			-r -q \
			-e modify -e close_write \
			-e create -e move -e move_self \
			-e delete -e delete_self \
            $WATCH_FILES

        echo "reloading nginx"
		kill -HUP $(cat /var/run/nginx.pid)
	done
}

watch_certs &
nginx -g "daemon off;" $@