#!/bin/bash

# Exit on first error, print all commands.
set -ev

#Detect architecture
ARCH=`uname -m`

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#
cd "${DIR}"/composer

ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose1.yml down
ARCH=$ARCH docker-compose -f "${DIR}"/composer/docker-compose1.yml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" lyra1.peers.aabo.tech peer channel create -o orderer.aabo.tech:7050 -c lyra-cli -f /etc/hyperledger/configtx/composer-channel.tx

# Join peer0.org1.example.com to the channel.
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@peers.aabo.tech/msp" lyra1.peers.aabo.tech peer channel join -b lyra-cli.block

docker exec cli.aabo.tech go build; 

docker exec cli.aabo.tech peer chaincode install -n mycc -v 1.0 -p sacc

docker exec cli.aabo.tech peer chaincode instantiate -o orderer.aabo.tech:7050 -C lyra-cli -n mycc -v 1.0 -c '{"Args":[""]}'7

docker exec cli.aabo.tech peer chaincode invoke -o orderer.aabo.tech:7050 -C lyra-cli -n mycc -v 1.0 -c '{"Args":["initWallet","A","100"]}'

docker exec cli.aabo.tech peer chaincode invoke -o orderer.aabo.tech:7050 -C lyra-cli -n mycc -c -c '{"Args":["readWallet","A"]}'

cd ../..
