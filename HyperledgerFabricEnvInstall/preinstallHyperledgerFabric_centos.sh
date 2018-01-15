#!/bin/bash

# Author: CavanLiu
# Email:liuyeying1103@163.com/code_captain@163.com
# QQ:247706624

# Hyperledger Fabric precondition installation
# Hyperledger Fabric Version 1.0.3
# Date: 2017/10/31
# OS: CentOS 7 x64

# Courses url follows:
# http://blog.csdn.net/mimica247706624/article/details/78412038
# http://blog.csdn.net/mimica247706624/article/details/47336027           

function echoColor()           
{                              
	echo -e "\033[35;1m$1\033[0m"# update os
}                              

function updateOS()
{
	yum update -y --skip-broken
	yum upgrade -y --skip-broken
}

# install docker precondition
function installPrecondition()
{
	echoColor "-----------------------------------------------------------------"
	echoColor "Start install docker precondition softwares,please wait......."

	echoColor "1.Install golang"
	yum install -y gcc openssl-devel gcc-c++ compat-gcc-34 compat-gcc-34-c++ curl-devel expat-devel gettext-devel zlib-devel perl-ExtUtils-MakeMaker
	yum install -y golang

	echoColor $GOPATH

	export GOPATH=$HOME/go
	export PATH=$PATH:$GOPATH/bin

	echoColor "2.Install Node.js Runtime and NPM"
	#npm install npm@latest -g	

	echoColor "3.Install python and python-pip"
	yum install -y python epel-release
	python --version

	yum install -y python-pip
	
	echoColor "3.1 Upgrade python-pip"
	pip install --upgrade pip backports.ssl_match_hostname

	echoColor "4.Install git"
	yum install -y git

	echoColor "5.Install nodejs"
	yum install -y nodejs	
	npm --version

	echoColor "Finish install docker precondition softwares!"
	echoColor "-----------------------------------------------------------------"
}

# install docker
function installDocker()
{
	echoColor "-----------------------------------------------------------------"
	echoColor "Start install docker,please wait......."

	echoColor "1.Install docker and start service"
	yes|cp -f ./docker.repo /etc/yum.repos.d/docker.repo
	yum install -y docker-engine
	systemctl start docker.service
	docker images
	
	echoColor "2.Install docker-compose"
	pip install docker-compose
	docker-compose --version

	echoColor "Finish install docker and docker-compose!"
	echoColor "-----------------------------------------------------------------"
}

# install the latest npm
function installNpm()
{
	echoColor "-----------------------------------------------------------------"
	echoColor "Start install npm,please wait......."
	
	echoColor "1.Installing global grpc"
	npm install --global grpc

	echoColor "Finish install npm!"
	echoColor "-----------------------------------------------------------------"
}

# pull docker images
function pullDockerImages()
{
	echoColor "1.Executing byfn.sh"
	cd ../fabric-samples
	chmod -R +x ./first-network/byfn.sh
	./byfn.sh
	
	echoColor "2.Change bootstrap.sh privilege"
	cd scripts
	chmod -R +x ./bootstrap.sh
	./bootstrap.sh
	
	echoColor "3.Copy network tools to /usr/local/bin"
	yes|cp bin/configtxgen /usr/local/bin/
	yes|cp bin/configtxlator /usr/local/bin/
	yes|cp bin/cryptogen /usr/local/bin/
	yes|cp bin/order /usr/local/bin/
	yes|cp bin/peer /usr/local/bin/
}

echoColor " ____    _____      _      ____    _____ "
echoColor "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echoColor "\___ \    | |     / _ \   | |_) |   | |  "
echoColor " ___) |   | |    / ___ \  |  _ <    | |  "
echoColor "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echoColor

updateOS;
installPrecondition;
installDocker;
installNpm;
pullDockerImages;

echoColor " _____   _   _   ____   "
echoColor "| ____| | \ | | |  _ \  "
echoColor "|  _|   |  \| | | | | | "
echoColor "| |___  | |\  | | |_| | "
echoColor "|_____| |_| \_| |____/  "
echoColor
