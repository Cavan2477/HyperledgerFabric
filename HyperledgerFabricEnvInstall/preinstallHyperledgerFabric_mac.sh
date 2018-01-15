#!/bin/bash

# Author: CavanLiu
# Email:liuyeying1103@163.com/code_captain@163.com
# QQ:247706624

# Hyperledger Fabric precondition installation
# Hyperledger Fabric Version 1.0.3
# Date: 2017/12/19
# OS: macOS 10.13.2

# Courses url follows:
# http://blog.csdn.net/mimica247706624/article/details/78412038
# http://blog.csdn.net/mimica247706624/article/details/47336027

# install Homebrew
function installHomebrew()
{
	# official installation
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	
	# brew update
	brew update --force
}

# install docker precondition
function installPrecondition()
{
	echo "-----------------------------------------------------------------"
	echo "Start install docker precondition softwares,please wait......."

	echo "1.Install golang"
	brew install -y golang
	go env

	echo $GOPATH

	# You can set $GOPATH by youself.This is common default setting.
	export GOPATH=$HOME/go
	export PATH=$PATH:$GOPATH/bin

	echo "2.Install Node.js Runtime and NPM"
	brew install -y node nodejs
	node -v
	
	npm install npm@latest -g	
	npm --version

	echo "3.Install python and python-pip"
	brew install -y python
	python --version

	brew install -y python-pip
	
	echo "3.1 Upgrade python-pip"
	pip install --upgrade pip backports.ssl_match_hostname

	echo "4.Install git"
	brew install -y git
	brew upgrade git
	git --version

	echo "Finish install docker precondition softwares!"
	echo "-----------------------------------------------------------------"
}

# install docker
function installDocker()
{
	echo "-----------------------------------------------------------------"
	echo "Start install docker,please wait......."

	echo "1.Installing docker"
	brew cask install virtualbox
	brew isntall -y docker docker-machine
	
	echo "1.1 Initializing virtual box default virtual machine"
	echo "Use already download image file boot2docker.iso."
	yes|cp -f ./boot2docker.iso $HOME/.docker/machine/cache/boot2docker.iso
	
	docker-machine create --driver virtualbox default
	docker-machine env default
	eval $(docker-machine env default)
	
	docker images
	docker ps
	
	echo "2.Install docker-compose"
	pip install docker-compose
	docker-compose --version

	echo "Finish install docker and docker-compose!"
	echo "-----------------------------------------------------------------"
}

# install the latest npm
function installNpm()
{
	echo "-----------------------------------------------------------------"
	echo "Start install npm,please wait......."
	
	echo "1.Installing global grpc"
	npm install --global grpc

	echo "Finish install npm!"
	echo "-----------------------------------------------------------------"
}

# pull docker images
function pullDockerImages()
{
	echo "1.Executing byfn.sh"
	cd ../fabric-samples
	chmod -R +x ./first-network/byfn.sh
	./byfn.sh
	
	echo "2.Change bootstrap.sh privilege"
	cd scripts
	chmod -R +x ./bootstrap.sh
	./bootstrap.sh
	
	echo "3.Copy network tools to /usr/local/bin"
	yes|cp bin/configtxgen /usr/local/bin/
	yes|cp bin/configtxlator /usr/local/bin/
	yes|cp bin/cryptogen /usr/local/bin/
	yes|cp bin/order /usr/local/bin/
	yes|cp bin/peer /usr/local/bin/
}

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo

installHomebrew;
installPrecondition;
installDocker;
pullDockerImages;

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo