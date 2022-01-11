#!/bin/sh

if [[ ! -f /etc/certs/fullchain.pem ]]
then
  openssl genrsa -out /etc/certs/privkey.pem 2048 
  openssl req -nodes -new -x509 -subj "/C=FR/ST=PACA/L=Marseille/O=Omneedia/OU=omneedia/CN=com/emailAddress=dummy@fake-cert.com" -key /etc/certs/privkey.pem > /etc/certs/fullchain.pem
fi

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