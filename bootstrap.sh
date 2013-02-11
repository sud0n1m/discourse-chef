#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev libxml2-dev libxslt1-dev
apt-get -y install ruby 
apt-get -y install ruby-dev
gem install chef ruby-shadow --no-ri --no-rdoc