#!/bin/sh

AUTOPROJ_INSTALL_URL=https://raw.githubusercontent.com/rock-core/autoproj/master/bin/autoproj_install
BOOTSTRAP_URL=git@github.com:romulogcerqueira/sonar_simulation-buildconf.git

set -e

mkdir -p ~/sonar_simulator/
cd ~/sonar_simulator/

[ -f "autoproj_install" ] || wget -nv ${AUTOPROJ_INSTALL_URL}
[ -d ".autoproj" ] || { mkdir -p .autoproj; cat <<EOF > .autoproj/config.yml; }
---
osdeps_mode: all
GITORIOUS: ssh
GITHUB: ssh
ROCK_SELECTED_FLAVOR: master
ROCK_FLAVOR: master
ROCK_BRANCH: master
USE_OCL: false
rtt_corba_implementation: omniorb
rtt_target: gnulinux
cxx11: false
EOF

export AUTOPROJ_OSDEPS_MODE=all
export AUTOPROJ_BOOTSTRAP_IGNORE_NONEMPTY_DIR=1

ruby autoproj_install
. ./env.sh
autoproj bootstrap git ${BOOTSTRAP_URL}