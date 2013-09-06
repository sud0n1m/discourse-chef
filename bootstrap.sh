#!/usr/bin/env bash
#update the update the system & install latest updates
apt-get -y update
apt-get -y upgrade
#install ruby dependancies
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev libxml2-dev libxslt1-dev

# For Ubuntu 12.10 you can just install ruby from the package
# apt-get install ruby
# apt-get install ruby-dev

# INSTALL RUBY from source
cd /tmp
wget https://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz
tar -xvzf ruby-1.9.3-p448.tar.gz
cd ruby-1.9.3-p448/
./configure --prefix=/usr/local
make
make install

# Update rubygems
gem update --system

# INSTALL CHEF
gem install chef ruby-shadow --no-document
