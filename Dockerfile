FROM ubuntu:18.04

HEALTHCHECK CMD netstat -an | grep 27015 > /dev/null; if [ 0 != $? ]; then exit 1; fi;													 

# Install dependencies and create steam user
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget lib32gcc1 lib32stdc++6 lib32tinfo5 net-tools && \
    rm -r /var/cache/apt/archives/* && \
    useradd steam -m

WORKDIR /home/steam
USER steam

# Download steamcmd
RUN mkdir content Steam tmp && \
    cd Steam && \
    wget http://media.steampowered.com/client/steamcmd_linux.tar.gz && \
    tar xzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Download Garry's mod and content of tf2 and css
RUN ./Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/gmodds +app_update 4020 validate +quit && \
    ./Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/tmp/tf2 +app_update 232250 validate +quit && \
    ./Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/tmp/css +app_update 232330 validate +quit && \
    mv /home/steam/tmp/css/cstrike /home/steam/content/ && \
    mv /home/steam/tmp/tf2/tf /home/steam/content/ && \
    # Cleanup
    rm -r /home/steam/tmp && \
    rm /home/steam/Steam/logs/*

# Add directories with additional content to mount.cfg
RUN echo '"mountcfg"' > /home/steam/gmodds/garrysmod/cfg/mount.cfg && \
    echo '{' >> /home/steam/gmodds/garrysmod/cfg/mount.cfg && \
    echo '"cstrike" "/home/steam/content/cstrike"' >> /home/steam/gmodds/garrysmod/cfg/mount.cfg && \
    echo '"tf" "/home/steam/content/tf"' >> /home/steam/gmodds/garrysmod/cfg/mount.cfg && \
    echo '}' >> /home/steam/gmodds/garrysmod/cfg/mount.cfg

USER root
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
