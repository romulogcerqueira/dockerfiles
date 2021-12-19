#!/bin/bash

. settings.sh

if [ ! -d "$PROJECT_PATH" ]; then
    mkdir -p "$PROJECT_PATH"

    if [ ! -d "$PROJECT_PATH" ]; then
        echo "Could not create $PROJECT_PATH's home"
        exit 1
    fi
fi

if [ ! -d "$PROJECT_PATH/.ssh" ]; then
    if [ ! -d "$HOME/.ssh" ]; then
        printf "Please, setup ssh keys before running the container\n"

        exit 1
    fi
    cp -R "$HOME/.ssh" "$PROJECT_PATH/"
fi

if [ ! -f "$PROJECT_PATH/.gitconfig" ]; then
    if [ ! -f "$HOME/.gitconfig" ]; then
        printf "Please, setup git before running the container\n\n"
        printf "Use: \n"
        printf "git config --global user.name \"John Doe\"\n"
        printf "git config --global user.email johndoe@example.com\n"

        exit 1
    fi
    cp "$HOME/.gitconfig" "$PROJECT_PATH/"
fi

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist "${DISPLAY}" | sed -e 's/^..../ffff/' | xauth -f "${XAUTH}" nmerge -

docker run -it \
        --rm \
        --net host \
        --volume=$XSOCK:$XSOCK:rw \
        --volume=$XAUTH:$XAUTH:rw \
        --volume=/etc/localtime:/etc/localtime:ro \
        --volume=$PROJECT_PATH:$HOME:rw \
        --env="XAUTHORITY=${XAUTH}" \
        --env="DISPLAY" \
        --env="TERM" \
        --user="$USER" \
        --workdir="$HOME" \
        --name ${PROJECT}_${DISTRO} \
        --ipc host \
        --privileged \
        --runtime=nvidia \
        --volume=${XSOCK}:${XSOCK}:rw \
        --volume=${XAUTH}:${XAUTH}:rw \
        --env=XAUTHORITY=${XAUTH} \
        --env=DISPLAY \
        ${PROJECT}_${DISTRO} \
        /bin/bash
