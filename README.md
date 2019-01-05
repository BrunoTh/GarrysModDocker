# GarrysModDocker
Run a Garry's Mod gameserver inside a docker container.

## Overview
This Docker image contains steamcmd, Garry's Mod and content from CSS and TF2.

## How to use
### Docker
After cloning this repository you have to build the Docker image (this may take a while because the steam server isn't very fast):

    $ docker build -t garrysmod .

Then you can start the server with:

    $ docker run -t -d -p 27005:27005/udp -p 27015:27015/udp garrysmod <parameters>

### docker-compose
If you want to use docker-compose instead, modify `docker-compose.yml` and start the stack with::

    $ docker-compose up -d


## Configuration
The configuration files are stored in the following directory `/home/steam/gmodds/garrysmod/cfg/`.

## Example
In this example we insert `server.cfg` into the container, set gamemode to `terrortown`, the initial map to `ttt_lego` and use the workshop collection `716717312`:

    $ docker run -t -d -p 27005:27005/udp -p 27015:27015/udp -v ./server.cfg:/home/steam/gmodds/garrysmod/cfg/server.cfg garrysmod +gamemode terrortown +map ttt_lego +host_workshop_collection 716717312

## TODO
- Add a volume for workshop collections.
