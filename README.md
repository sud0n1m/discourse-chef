This collection of chef recipes should help you get bootstrap a VPS to run (https://github.com/discourse/discourse). Start with a blank Ubuntu 12.04 VPS.

## Gets you a working server ready to cap deploy discourse.

Clone this repo:

    git clone https://github.com/sud0n1m/discourse-chef

### 1. Get librarian chef and the packages installed

On your local machine:

    cd discourse-chef
    gem install librarian-chef
    librarian-chef install

### 2. Bootstrap your server

    SERVER="yourdomain.com"

    # Install Instructions

    # enter your password once and never again
    ssh-copy-id root@$SERVER

    # Copy the bootstrap file and run it
    rsync -r . root@$SERVER:/var/chef && ssh root@$SERVER "sh /var/chef/bootstrap.sh"

    # Install chef services
    librarian-chef install && rsync -r . root@$SERVER:/var/chef && ssh root@$SERVER "chef-solo -c /var/chef/solo.rb"

    # Copy the deploy user to the server
    ssh-copy-id deploy@$SERVER

    # From the discourse directory, run capistrano
    # Here's an example.
    # https://gist.github.com/sud0n1m/4953154

    cap deploy 

    # If hstore doesn't work

    ssh deploy@$SERVER
    sudo su postgres
    psql -d discourse
    CREATE EXTENSION hstore;
    \q
    exit

    # Migrate the database to set it up
    cd /web/discourse/current
    bundle exec rake db:migrate

    # Log in and create your first user!
    # Then go and make them an admin

    ssh deploy@$SERVER1
    cd /web/discourse/current
    bundle exec rails c

    u = User.first
    u.admin = true
    u.save

    exit
