# If you want to test these chef scripts, a vagrant box is a great way to do it!

Vagrant::Config.run do |config|
  config.vm.box = 'ubuntu-1204-64bit' # does not work on amd_64
  config.vm.box_url = 'http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box'
  config.vm.network :hostonly, '192.168.10.200'

  if RUBY_PLATFORM =~ /darwin/
    config.vm.share_folder("v-cookbooks", "/var/chef", ".", :nfs => true)
  end
end