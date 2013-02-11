## Gets you mostly there...

Change some configuration options in Node.json

### 1. Installing

Spin up a VPS. Run the commands in bootstrap.sh

### 2. Get the packages

  gem install librarian-chef
  librarian-chef install

### 3. Rsync them to your server
  
  rsync -r . root@yourserver:/var/chef       
  
### 4. Run chef solo

  ssh root@yourserver "chef-solo -c /var/chef/solo.rb"

### 5. Now set stuff up...

This is as far as I've got... what you have now is:

* Redis
* Postgresql
** A database called "discourse"
** A user called deploy with rights on the database
* Nginx
** A configuration proxying a single thin server on port 3000
* A user named "deploy"

You'll need to get the application server running, run the commands to migrate and seed the database and figure out a good deploy process, but there servers there.
