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

CONTAINER_USER=${USER}-${PROJECT}
CONTAINER_NAME=${PROJECT}_${DISTRO}"_devel"

if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    if [ ! "$(docker ps -aq -f status=exited -f name=${CONTAINER_NAME})" ]; then
        echo "Create docker"
        docker create -it \
            --net host \
            --volume="${PROJECT_PATH}:/home/${CONTAINER_USER}:rw" \
            --volume="/etc/localtime:/etc/localtime:ro" \
            --env="TERM" \
            --user="${CONTAINER_USER}" \
            --workdir="/home/${CONTAINER_USER}" \
            --name ${CONTAINER_NAME} \
            --privileged \
            --runtime=nvidia \
            --volume=${XSOCK}:${XSOCK}:rw \
            --volume=${XAUTH}:${XAUTH}:rw \
            --env=XAUTHORITY=${XAUTH} \
            --env=DISPLAY \
            ${PROJECT}_${DISTRO}:"devel"
    fi
    echo "Start docker"
    docker start -ai ${CONTAINER_NAME}
else
    echo "Exec docker"
    docker exec -ti ${CONTAINER_NAME} /bin/bash
fi
