#!/bin/bash

. settings.sh

function usage() {
    printf "Usage: $0 [options] [distro] [project] [username]\n"
    printf "Build image based on ubuntu [distro] image using [project] as prefix for the image name\n\n"
    printf "Options:\n"
    printf "  -h|--help\t\t Shows this help message\n"
    printf "  --distro DISTRO\t Ubuntu distro of the base image ('xenial', 'bionic', 'focal')\n"
    printf "  --project PROJECT\t Project name (e.g. mccr, jiro). Prefix of the image name\n"    
    exit 0
}

while [ -n "$1" ]; do
    case $1 in
        -h|--help) usage;;
        -d|--distro)
            DISTRO=$2
            shift
            ;;
        -p|--project)
            PROJECT=$2
            shift
            ;;
        -?*)
            echo "WARN: Unknown option passed (ignored)"
            exit 1;;
        *)
            break
    esac
    shift
done

case ${DISTRO} in
    "xenial")
        BASE_IMAGE="nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04";;
    "bionic")
        BASE_IMAGE="nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04";;
    "focal")
        BASE_IMAGE="nvidia/opengl:1.0-glvnd-runtime-ubuntu20.04";;
    *)
        echo "Ubuntu distro invalid! Checks the file settings.sh"
        exit 1;;
esac

IMAGE_NAME=${PROJECT}_${DISTRO}:devel

docker build  \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    --build-arg USERNAME=${PROJECT} \
    --build-arg UUID=${UUID} \
    --build-arg UGID=${UGID} \
    --compress \
    -t ${PROJECT}_${DISTRO}:devel .
