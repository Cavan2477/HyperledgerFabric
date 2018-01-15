#!/bin/bash
set -e

# １　下载 SDK
git clone https://github.com/hyperledger/fabric-sdk-node.git
sleep 1

# 2 安装依赖
npm install
npm install -g gulp
gulp ca

# 3 拷贝docker-compose 文件到SDK指定文件夹
#cd ../
#yes|cp ./docker-compose-marblesv3.yaml fabric-sdk-node/test/fixtures

# 4 拷贝配置文件到SDK指定文件夹
#cp ./config.json fabric-sdk-node/test/integration/e2e