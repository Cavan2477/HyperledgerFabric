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

USER_BIN=/usr/bin

SHELL_BOOTSTRAP=bootstrap.sh
SHELL_BYFN=byfn.sh

DIR_FABRIC_SAMPLES=fabric-samples
DIR_FABRIC_FIRST_NETWORK=first-network
DIR_SCRIPTS=scripts

DIR_GO_PATH=/home/go
DIR_GO_INSTALLED=/usr/local/go
DIR_LOCAL_BIN=/usr/local/bin

DIR_GITHUB_HYPERLEDGER=src/github.com/hyperledger

TAR_GO_NAME=go1.9.1.linux-amd64.tar.gz

URL_FABRIC=github.com/hyperledger/fabric
URL_FABRIC_CHAINTOOL=github.com/hyperledger/fabric-chaintool/releases/download/v0.10.3/chaintool

# echo print with color
function echoColor()
{
	echo -e "\033[35;1m$1\033[0m"
}

# update os
function updateOS()
{
	echoColor "Updating system to newest version"
	
	sudo apt-get update -y --fix-missing
	sudo apt-get upgrade -y --fix-missing
	sudo apt-get autoremove -y
	sudo apt-get clean
	sudo apt-get install -f -y
	
	echo 
}

# remove golang-go
function removeGolang()
{
	echoColor "0.Remove golang-go"
	echo 
	sudo apt-get remove -y golang-go
	sudo apt-get autoremove -y
	
	echo 
	sudo rm -rf $DIR_GO_INSTALLED
	sudo rm -rf $USER_BIN/go
	
	echo
}

# install Golang-go
function installGolang()
{
	# Remove golang-go
	removeGolang;
	
	echo
	sudo apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libltdl-dev libtool
	
	echo
	echoColor "1.1 Replace golang with higher version, and modify link for /usr/bin/go"
	#sudo curl -O https://storage.googleapis.com/golang/$TAR_GO_NAME
	
	tar -xvf tar/$TAR_GO_NAME
	sudo mv -f go $DIR_GO_INSTALLED
	
	echoColor "1.2 Modify link /usr/bin/go to /usr/lib/go-1.9.1/bin/go"
	echo
	#sudo rm -rf /usr/lib/go
	sudo ln -s $DIR_GO_INSTALLED/bin/go $USER_BIN/go
	
	if [ ! -d "${DIR_GO_PATH}" ]; then
		sudo mkdir -p $DIR_GO_PATH
	fi

	echo 
	echoColor $GOPATH

	export GOPATH=$DIR_GO_PATH
	export PATH=$PATH:$DIR_GO_INSTALLED/bin:$PATH/bin
	
	go env
	go version
	
	# Result show: go version go1.9.1 linux/amd64 is OK
	
	echo
}

# install Node.js Runtime and NPM
function installNodejs()
{
	echo
	
	sudo apt-get install -y nodejs
	nodejs version

	sudo apt-get install -y npm
	sudo npm install --global grpc
	sudo npm install npm@latest -g
	npm version
	
	echo
}

# install python
function installPythonAndPip()
{
	echo 
	
	sudo apt-get install -y aptitude
	sudo apt-get install -y python
	sudo apt autoremove
	python --version
	
	echo 
	
	echoColor "Install and update python-pip"
	sudo apt-get install -y python-pip
	sudo pip install --upgrade pip backports.ssl_match_hostname
	
	echo 
}

# install git
function installGit()
{
	echo 
	
	sudo apt-get remove -y git
	sudo apt-get autoremove -y git
	sudo apt-get install -y git
	
	echo
}

# install docker
function installDocker()
{
	echo
	echoColor "-----------------------------------------------------------------"
	echoColor "Start install docker,please wait......."

	echoColor "1.Install docker and start service"
	sudo apt-get install -y docker
	
	echoColor "1.2 Use systemd manager"
	echoColor "Tips:"
	echoColor "Docker configuration file is /etc/systemd/system/docker.service.d/override.conf"
	DOCKER_OPTS="$DOCKER_OPTS -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --api-cors-header='*'"
	
	sudo systemctl daemon-reload
	sudo systemctl restart docker.service
	
	echo
	docker images
	
	echo
	echoColor "2.Install docker-compose then higher 1.8.0"
	sudo pip install docker-compose>=1.8.0
	docker-compose --version

	echoColor "Finish install docker and docker-compose!"
	echoColor "-----------------------------------------------------------------"
	echo
}

# download tools
function downloadTools()
{
	# copy or download tools
	echo 
	echoColor "Copy *.sh"
	
	if [ ! -s "../{$DIR_FABRIC_SAMPLES}/{$DIR_SCRIPTS}/{$SHELL_BOOTSTRAP}" ]; then
		sudo yes|cp -f $SHELL_BOOTSTRAP ../$DIR_FABRIC_SAMPLES/$DIR_SCRIPTS/
		
		echo
		echoColor "Download tools"
		
		if [ ! -s "bin/configtxgen" -o \
				 ! -s "bin/configtxlator" -o \
				 ! -s "bin/cryptogen" -o \
				 ! -s "bin/orderer" -o \
				 ! -s "bin/peer" ]; then
			sudo ./$SHELL_BOOTSTRAP		
		fi
	fi
	
	#echo
	#echoColor "Executing byfn.sh"
	#cd ../$DIR_FABRIC_SAMPLES/$DIR_FABRIC_FIRST_NETWORK
	
	#sudo chmod -R +x $SHELL_BYFN
	#sudo ./$SHELL_BYFN
}

# pull docker images
function pullDockerImages()
{
	echo
	
	echoColor "Change bootstrap.sh privilege"
	sudo chmod -R +x $SHELL_BOOTSTRAP
	sudo ./$SHELL_BOOTSTRAP
	
	echo
}

# Download fabric sample codes fabric and fabric-ca
function downloadFabricCodes()
{
	echo
	echoColor "Get fabric sample codes fabric and fabric-ca"
	echoColor $DIR_GO_PATH
	
	if [ ! -d "{$DIR_GO_PATH}/{$DIR_GITHUB_HYPERLEDGER}" ]; then
		sudo mkdir -p $DIR_GO_PATH/$DIR_GITHUB_HYPERLEDGER
	
		cd $DIR_GO_PATH/$DIR_GITHUB_HYPERLEDGER
	
		sudo git clone http://gerrit.hyperledger.org/r/fabric 
		sudo git clone http://gerrit/hyperledger.org/r/fabric-ca	
	fi
}

# Compile fabric peer and order manually
function compileFabricPeerAndOrder() 
{
	cd $DIR_GO_PATH/$DIR_GITHUB_HYPERLEDGER/fabric
	
	echoColor "${URL_FABRIC}"
	
	export GOPATH=$DIR_GO_PATH
	
	echo
	echoColor "-----------------------------------------------------------------"
	echoColor "Start compile peer, please wait......"
	
	ARCH=x86_64
	BASEIMAGE_RELEASE=0.3.1
	PROJECT_VERSION=1.0.0
	LD_FLAGS="-X ${URL_FABRIC}/common/metadata.Version=${PROJECT_VERSION} \
						-X ${URL_FABRIC}/common/metadata.BaseVersion=${BASEIMAGE_RELEASE} \
						-X ${URL_FABRIC}/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
						-X ${URL_FABRIC}/common/metadata.DockerNamespace=hyperledger \
						-X ${URL_FABRIC}/common/metadata.BaseDockerNamespace=hyperledger"
	CGO_CFLAGS=" " go install -ldflags "$LD_FLAGS -linkmode external -extldflags '-static -lpthread'" $URL_FABRIC/peer
	
	echoColor "Finish compiled peer."
	echoColor "-----------------------------------------------------------------"
	echo
}

# Compile fabric tools manually
function compileFabricTools() 
{	
	export GOPATH=$DIR_GO_PATH
	
	echo
	echoColor "-----------------------------------------------------------------"
	echoColor "Start compile tools, please wait......"
	
	PROJECT_VERSION=1.0.0
	
	CGO_CFLAGS=" " go install -tags "" -ldflags "-X ${URL_FABRIC}/common/tools/cryptogen/metadata.Version=${PROJECT_VERSION}" $URL_FABRIC/common/tools/cryptogen
	
	# Have some errors
	#CGO_CFLAGS=" " go install -tags "nopkcs11" -ldflags "-X ${URL_FABRIC}/common/tools/configtx/tool/configtxgen/metadata.Version=${PROJECT_VERSION}" $URL_FABRIC/common/configtx/tool/configtxgen
	#CGO_CFLAGS=" " go install -tags "" -ldflags "-X ${URL_FABRIC}/common/tools/configtxlator/metadata.Version=${PROJECT_VERSION}" $URL_FABRIC/common/tools/configtxlator
	
	echoColor "Finish compiled tools."
	echoColor "-----------------------------------------------------------------"
	echo
}

# Download chaintool
function downloadChaintool()
{
	echo
	echoColor "-----------------------------------------------------------------"
	echoColor "Start download chaintool......"
	
	if [ ! -s "tools/chaintool" ]; then
		curl -L https://$URL_FABRIC_CHAINTOOL > ./tools/chaintool
	fi
	
	sudo yes|cp -f ./tools/chaintool > $DIR_LOCAL_BIN/chaintool
	sudo chmod -R a+x $DIR_LOCAL_BIN/chaintool
	
	echoColor "Finish download chaintool."
	echoColor "-----------------------------------------------------------------"
	echo
}

# Download golang tools
function downloadGolangTools()
{
	export GOPATH=$DIR_GO_PATH
	
	echo
	echoColor "-----------------------------------------------------------------"
	echoColor "Start download some tools for golang debug, please wait......"
	
	sudo go get github.com/golang/protobuf/protoc-gen-go
	sudo go get github.com/golang/lint/golint
	sudo go get github.com/kardianos/govendor
	sudo go get github.com/onsi/ginkgo/ginkgo
	sudo go get github.com/axw/gocov/...
	sudo go get github.com/client9/misspell/cmd/misspell
	sudo go get github.com/AlekSi/gocov-xm
	sudo go get golang.org/x/tools/cmd/goimports
				
	echoColor "Finish download."
	echoColor "-----------------------------------------------------------------"
	echo
}

# install docker precondition
function installPrecondition()
{
	echoColor "-----------------------------------------------------------------"
	echoColor "Start install precondition dependency items, please wait......."
	
	echoColor "1.Install golang-go"
	installGolang;

	echoColor "2.Install Node.js Runtime and NPM"
	installNodejs;

	echoColor "3.Install python and python-pip"
	installPythonAndPip;

	echoColor "4.Install git"
	installGit;
	
	echoColor "Finish installed precondition dependency items."
	echoColor "-----------------------------------------------------------------"
}

echoColor " ____    _____      _      ____    _____ "
echoColor "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echoColor "\___ \    | |     / _ \   | |_) |   | |  "
echoColor " ___) |   | |    / ___ \  |  _ <    | |  "
echoColor "|____/    |_|   /_/   \_\ |_| \_\   |_|  "

updateOS;
installPrecondition;
installDocker;
downloadTools;
pullDockerImages;
downloadFabricCodes;
compileFabricPeerAndOrder;
compileFabricTools;
downloadChaintool;
downloadGolangTools;

echoColor " _____   _   _   ____   "
echoColor "| ____| | \ | | |  _ \  "
echoColor "|  _|   |  \| | | | | | "
echoColor "| |___  | |\  | | |_| | "
echoColor "|_____| |_| \_| |____/  "
