#!/bin/bash

# Author: CavanLiu
# Email:liuyeying1103@163.com/code_captain@163.com
# Blog: http://blog.csdn.net/mimica247706624

# Hyperledger Fabric precondition installation
# Hyperledger Fabric Version 1.0.3
# Date: 2017/10/31
# OS: Ubuntu 16.04 x64

# Courses url follows:
# http://blog.csdn.net/mimica247706624/article/details/78412038
# http://blog.csdn.net/mimica247706624/article/details/47336027

PATH_ETC_FABRIC=/etc/hyperledger/fabric
PATH_CORE_PEER_MSP_CONFIG=${PATH_ETC_FABRIC}/crypto-config/peerOrganizations

DOMAIN_NAME=example.com
DOMAIN_PEER=org1.example.com
DOMAIN_ORDERER=orderer.example.com
DOMAIN_TLS_CA=tlsca.example.com

MSP_USER_ADMIN=Admin@${DOMAIN_PEER}

PATH_ETC_FABRIC_CRYPTO_CONFIG=${PATH_CORE_PEER_MSP_CONFIG}/${DOMAIN_PEER}/users/${MSP_USER_ADMIN}/msp
PATH_FILE_CA=${PATH_CORE_PEER_MSP_CONFIG}/${DOMAIN_NAME}/orderers/${DOMAIN_ORDERER}/msp/tlscacerts/${DOMAIN_TLS_CA}-cert.pem

CHANNEL_NAME=businesschannel

CORE_PEER_LOCALMSPID=Org1MSP

# echo print with color
function echoColor()
{
	echo -e "\033[35;1m$1\033[0m"
}

# Generate orgnization and authorization key files
function genOrgAndKey()
{
	echoColor "Start generate orgnization and authorization key files, please wait......"
	
	cryptogen generate --config=./crypto-config.yaml --output ./crypto-config
	
	if [ ! -d "{$PATH_ETC_FABRIC}" ]; then
		sudo mkdir -p $PATH_ETC_FABRIC
	fi
	
	#sudo yes|cp -f 
}

# Create channel
function createChannel()
{
	echo
	echoColor "Creating channels, please wait......"
	
	echoColor "CORE_PEER_MSPCONFIGPATH=\
						/etc/hyperledger/fabric/crypto-config/peerOrganizations/\
						org1.example.com/users/Admin@org1.example.com/msp \
						peer channel create \
						-o orderer.example.com:7050 \
						-c ${CHANNEL_NAME} \
						-f ./businesschannel.tx \
						--tls \
						--cafile \
						/etc/hyperledger/fabric/crypto-config/ordererOrganizations/\
						example.com/orderers/orderer.example.com/msp/tlscacerts/\
						tlsca.example.com-cert.pem"
	
	CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID \
	CORE_PEER_MSPCONFIGPATH=$PATH_ETC_FABRIC_CRYPTO_CONFIG \
	peer channel create \ 
	-o $DOMAIN_ORDERER:7050 \
	-c $CHANNEL_NAME \
	-f ./businesschannel.tx \
	-tls \
	--cafile $PATH_FILE_CA
	
	echoColor "Created channels finish."
	echo
}

echoColor " ____    _____      _      ____    _____ "
echoColor "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echoColor "\___ \    | |     / _ \   | |_) |   | |  "
echoColor " ___) |   | |    / ___ \  |  _ <    | |  "
echoColor "|____/    |_|   /_/   \_\ |_| \_\   |_|  "

createChannel;

echoColor " _____   _   _   ____   "
echoColor "| ____| | \ | | |  _ \  "
echoColor "|  _|   |  \| | | | | | "
echoColor "| |___  | |\  | | |_| | "
echoColor "|_____| |_| \_| |____/  "