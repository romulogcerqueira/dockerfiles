#!/bin/bash

# The project name
PROJECT="myproject"

# The Ubuntu distro which you will work on. Options are "xenial", "bionic" and "focal"
DISTRO="focal"

# Set Project's home path here
PROJECT_PATH="${HOME}/workspace/${PROJECT}_${DISTRO}"

# The name of the user inside the container.
CONTAINER_USER=${PROJECT}

# The host name of the container.
CONTAINER_HOSTNAME=${DISTRO}

# Don't change these unless you know what you are doing
UUID="$(id -u)"
UGID="$(id -g)"
