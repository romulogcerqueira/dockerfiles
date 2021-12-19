#!/bin/bash

# The project name
PROJECT="myproject"

# The Ubuntu distro which you will work on. Options are "xenial", "bionic" and "focal"
DISTRO="focal"

# Set Sonarsim's home path here
PROJECT_PATH="$HOME/workspace/${PROJECT}_${DISTRO}"

# Don't change these unless you know what you are doing
USER="$(id -nu)"
UUID="$(id -u)"
UGID="$(id -g)"

export PROJECT_PATH
export USER
export UUID
export UGID