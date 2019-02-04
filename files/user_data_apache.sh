#!/bin/bash -x

install_apache2() {
    apt-get update && apt-get install -y apache2
	return $?
}

retry=0

until [ "$retry" -ge 5 ]
do
    retry=$[$retry+1]
    sleep 1
    echo "Retry $retry"
    install_apache2 && break
    echo "$result"
done