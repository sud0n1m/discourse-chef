This collection of chef recipes should help you get bootstrap a VPS to run (https://github.com/discourse/discourse). Start with a blank Ubuntu 12.10 VPS.

## Gets you mostly there...

Clone this repo:

    git clone https://github.com/sud0n1m/discourse-chef

### 1. Get librarian chef and the packages installed

On your local machine:

    cd discourse-chef
    gem install librarian-chef
    librarian-chef install

### 2. Bootstrap your server

    rsync -r . root@yourserver:/var/chef
    ssh root@yourserver "sh /var/chef/bootstrap.sh" 

### 3. Tweak the settings
  
Change the password and server name in the `node.json` file. Then sync the changes

    rsync -r . root@yourserver:/var/chef
  
### 4. Run chef solo

    ssh root@yourserver "chef-solo -c /var/chef/solo.rb"
    
You should see a lot of output as things are being installed. This may take 5 - 10 minutes.

### 5. Now the last mile is up to you...

This is as far as I got... what you have now is:

* Redis
* Postgresql
** A database called "discourse"
** A user called deploy with rights on the database
* Nginx
** A configuration proxying a single thin server on port 3000
* A user named "deploy" with a password you set in `Node.json`

You'll need to get the application server running, run the commands to migrate and seed the database and figure out a good deploy process, but there servers there.
