


    librarian-chef install
    rsync -r . root@198.74.62.188:/var/chef       
    ssh root@198.74.62.188 "chef-solo -c /var/chef/solo.rb"

