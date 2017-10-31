#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
cd "${DIR}"/composer

ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml down
ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose.yml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec lyra1.peers.aabo.tech peer channel create -o orderer.aabo.tech:7050 -c composerchannel -f /etc/hyperledger/configtx/composer-channel.tx

# Join peer0.org1.example.com to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" lyra1.peers.aabo.tech peer channel join -b composerchannel.block

cd ../..
