package "git-core" # apt-get install git-core
package "zsh"
package "vim"

# Note that all recipes in here also need to be in metadata.rb
include_recipe "redis::default"

## REDIS FAILED TO INSTALL WITH THIS. DID IT MANUALLY
## apt-get install redis-server


user node[:user][:name] do
  password node[:user][:password]
  gid "sudo"  
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/zsh"
end

template "/home/#{node[:user][:name]}/.zshrc" do
  source "zshrc.erb"
  owner node[:user][:name]
end


######## POSTGRES #############

include_recipe "postgresql::server"

package "postgresql-contrib"

########### NGINX ############

include_recipe "nginx"

# Create a directory for Discourse
directory "/home/#{node[:user][:name]}/#{node[:app][:name]}" do
  owner node[:user][:name]
end

file "/home/#{node[:user][:name]}/#{node[:app][:name]}/current/index.html" do
  owner node[:user][:name]
  content "<h1>Hello World!</h1>"
end

template "#{node[:nginx][:dir]}/sites-available/#{node[:app][:name]}" do
  source "discourse-nginx.erb"
end

nginx_site "#{node[:app][:name]}"


########### DEPLOY #############

# deploy "/home/#{node[:user][:name]}/#{node[:app][:name]}" do
#   repo "https://github.com/discourse/discourse.git"
#   revision "HEAD" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
#   user "deploy_ninja"
#   #enable_submodules true
#   migrate true
#   migration_command "rake db:migrate"
#   environment "RAILS_ENV" => "production", "OTHER_ENV" => "foo"
#   shallow_clone true
#   action :deploy # or :rollback
#   restart_command "touch tmp/restart.txt"
#   git_ssh_wrapper "wrap-ssh4git.sh"
#   scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
# end


########### RESTART NGINX ########

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start, :reload ]
end



# Install bundler
# gem install bundler

# check out the source
# git clone https://github.com/discourse/discourse.git .

# bundle install
# rake db:create
# rake db:migrate
# rake db:seed_fu
# redis-cli flushall
# thin start 