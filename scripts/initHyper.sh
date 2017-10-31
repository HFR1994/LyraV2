#!/bin/bash

# Exit on first error, print all commands.
set -v

#Make directory dist
mkdir dist

#Compile the file
composer archive create -a dist/lyra-cli.bna --sourceType dir --sourceName ../LyraV2/

#Deploy
composer network deploy -a dist/lyra-cli.bna -p hlfv1 -i PeerAdmin -s randomString -A admin -S
