#!/bin/bash

echo "Fixing permissions."
chown steam:steam -R /home/steam/gmodds/garrysmod/{cache,addons,data}

echo "Running srcds_run as steam-user."
ARGS="$@"
su - steam -c "/home/steam/gmodds/srcds_run -game garrysmod $ARGS"

