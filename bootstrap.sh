#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev libxml2-dev libxslt1-dev

# For Ubuntu 12.10 you can just install ruby from the package
# apt-get install ruby
# apt-get install ruby-dev

# INSTALL RUBY
cd /tmp
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p385.tar.gz
tar -xvzf ruby-1.9.3-p385.tar.gz
cd ruby-1.9.3-p385/
./configure --prefix=/usr/local
make
make install

# INSTALL CHEF
gem install chef ruby-shadow --no-ri --no-rdoc