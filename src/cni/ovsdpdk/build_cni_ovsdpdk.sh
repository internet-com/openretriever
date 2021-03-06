#!/bin/bash

set -ex

sudo apt-get update
sudo apt-get install -y docker.io devscripts git
wget -qO- https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
echo 'export GOPATH=/go; export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH' >> ~/.bashrc
export GOPATH=/go; export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH
git clone https://github.com/containernetworking/cni
echo sudo CNI_PATH=$CNI_PATH ./priv-net-run.sh ifconfig
git clone https://github.com/containernetworking/plugins
cd plugins
git checkout 5544d9ced0d6e908fe26e9dbe529c7feb87d21f5
patch -p1 < /vagrant/ovsdpdk.patch
./build.sh
cd bin
cp /vagrant/* .
sudo docker build -t openretriever/cni-ovsdpdk .
