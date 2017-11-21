#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
cd "${DIR}"/composer

ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose_peers2.yml down
ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose_peers2.yml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" lyra2.peers.aabo.tech peer channel fetch oldest lyra-cli.block -o ec2-54-218-80-223.us-west-2.compute.amazonaws.com:7050 -c lyra-cli

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" lyra2.peers.aabo.tech peer channel join -b lyra-cli.block

cd ../..
