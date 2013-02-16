## Testing these chef scripts with vagrant

The first time, run:
    vagrant up

This downloads the Ubuntu 12.04 AMD64 image from internets and boots it.

    vagrant ssh
    sudo su

This makes you the root user. You'll need to modify the instructions in the Readme for vagrant. You won't need to rsync since the local directory is available at `/var/chef`. 

**Any changes you make locally are immediately available available in the VM**

## Stopping vagrant
    vagrant halt

## Destroying your vagrant box

To test that the changes are working properly, you'll want to start with a bare box every now and then. 
    vagrant destroy