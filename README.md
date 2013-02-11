## Gets you mostly there...

Clone this repo:

    git clone https://github.com/sud0n1m/discourse-chef

Change the password and server name in the file `Node.json`

### 1. Installing

Spin up your new VPS running Ubuntu 12.10. Run the commands in `bootstrap.sh`

### 2. Get the packages

    gem install librarian-chef
    librarian-chef install

### 3. Rsync them to your server
  
From the discourse-chef directory (make sure to replace yourserver with an ip for your server):

    rsync -r . root@yourserver:/var/chef       
  
### 4. Run chef solo

    ssh root@yourserver "chef-solo -c /var/chef/solo.rb"
    
You should see a lot of output as things are being installed. This may take 5 - 10 minutes.

### 5. Now the last mile is up to you...

This is as far as I have got... what you have now is:

* Redis
* Postgresql
** A database called "discourse"
** A user called deploy with rights on the database
* Nginx
** A configuration proxying a single thin server on port 3000
* A user named "deploy" with a password you set in `Node.json`

You'll need to get the application server running, run the commands to migrate and seed the database and figure out a good deploy process, but there servers there.
