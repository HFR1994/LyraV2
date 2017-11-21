#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
cd "${DIR}"/composer

ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose_peers4.yml down
ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose_peers4.yml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" peering.peers.aabo.tech peer channel create -c lyra-cli

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" peering.peers.aabo.tech peer channel join -b lyra-cli.block

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp CORE_PEER_ADDRESS=ec2-54-218-80-223.us-west-2.compute.amazonaws.com:7051" peering.peers.aabo.tech peer channel join -b lyra-cli.block

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp CORE_PEER_ADDRESS=ec2-54-229-165-217.eu-west-1.compute.amazonaws.com:7051" peering.peers.aabo.tech peer channel join -b lyra-cli.block

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp CORE_PEER_ADDRESS=ec2-52-77-222-245.ap-southeast-1.compute.amazonaws.com:7051" peering.peers.aabo.tech peer channel join -b lyra-cli.block

cd ../..
