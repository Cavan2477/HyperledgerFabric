#!/bin/bash

# 生成证书
sudo ./bin/cryptogen generate --config=./crypto-config.yaml

# 创建创世区块
FABRIC_CFG_PATH=$PWD

sudo ./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block