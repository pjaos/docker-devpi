#!/bin/bash

#set -x
set -e

function defaults {
    : ${DEVPI_SERVERDIR="/data/server"}
    : ${DEVPI_CLIENTDIR="/data/client"}

    echo "DEVPI_SERVERDIR is ${DEVPI_SERVERDIR}"
    echo "DEVPI_CLIENTDIR is ${DEVPI_CLIENTDIR}"

    export DEVPI_SERVERDIR DEVPI_CLIENTDIR
}

function delayed_server_init {
    sleep 10
    echo "[RUN]: Setting up devpi server now it is running."
    devpi use http://localhost:3141
    devpi login root --password=''
    devpi user -m root password="${DEVPI_PASSWORD}"
    devpi index -y -c public pypi_whitelist='*'
}

function initialise_devpi {
    echo "[RUN]: Initialise devpi-server"
    devpi-init
    devpi-gen-config
    delayed_server_init &
}

defaults
echo "Startup cmd: $1"

if [ "$1" = 'devpi' ]; then
    echo "devpi command"
    if [ ! -f  $DEVPI_SERVERDIR/.serverversion ]; then
        echo "$DEVPI_SERVERDIR/.serverversion does not exist"
        initialise_devpi
    fi
    echo "[RUN]: Launching devpi-server"
    exec devpi-server --restrict-modify root --host 0.0.0.0 --port 3141
fi

echo "[RUN]: Builtin command not provided [devpi]"
echo "[RUN]: $@"

exec "$@"
