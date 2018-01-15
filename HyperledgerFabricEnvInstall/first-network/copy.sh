#!/bin/bash

PATH_ETC_HYPERLEDGER_FABRIC=/etc/hyperledger/fabric/

# copy files for starting orderer
yes|cp -f orderer.yaml $PATH_ETC_HYPERLEDGER_FABRIC
yes|cp -f orderer.genesis.block $PATH_ETC_HYPERLEDGER_FABRIC
yes|cp -rf crypto-config $PATH_ETC_HYPERLEDGER_FABRIC

# copy files for starting peer
yes|cp -f core.yaml $PATH_ETC_HYPERLEDGER_FABRIC
yes|cp -rf crypto-config $PATH_ETC_HYPERLEDGER_FABRIC



