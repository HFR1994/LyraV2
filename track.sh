#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git reset --hard

git clean -fd

git pull origin master

#
"${DIR}"/fabric-scripts/hlfv1/startFabric.sh