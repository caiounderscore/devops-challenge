#!/bin/bash -x

install_nginx() {
    apt-get update && apt-get install -y nginx
	return $?
}

retry=0

until [ "$retry" -ge 5 ]
do
    retry=$[$retry+1]
    sleep 1
    echo "Retry $retry"
    install_nginx && break
done