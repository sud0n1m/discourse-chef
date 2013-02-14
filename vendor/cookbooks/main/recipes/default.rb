# Note that all external recipes required in here also need to be in metadata.rb

package "git-core"
package "zsh"
package "vim"

gem_package "bundler"

########### SET UP USER ###########

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

########### SET UP APP DIRECTORY ###########

directory node[:app][:path] do
  owner "deploy"
  recursive true
  mode 0755
end

directory node[:app][:path]+"/shared" do
  owner "deploy"
end

directory node[:app][:path]+"/releases" do
  owner "deploy"
end


%w(config log tmp sockets pids).each do |dir|
  directory "#{node[:app][:path]}/shared/#{dir}" do
    owner "deploy"
    recursive true
    mode 0755
  end
end

############ RUBY ##################

# You MUST put this before the recipe is included.
node.default['rbenv']['rubies'] = ["1.9.3-p385"]

include_recipe "rbenv::system"


########### REDIS ################

include_recipe "redis::source"

######## POSTGRES #############

package "postgresql-contrib-9.2"

package "postgresql-server-dev-9.2"

include_recipe "postgresql::server"

## User and database is created in Node.json

########### NGINX ############

include_recipe "nginx"

# Create a directory for Discourse
directory "/home/#{node[:user][:name]}/#{node[:app][:name]}" do
  owner node[:user][:name]
end

template "#{node[:nginx][:dir]}/sites-available/#{node[:app][:name]}" do
  source "discourse-nginx.erb"
end

nginx_site "#{node[:app][:name]}"

########### RESTART NGINX ########

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start, :reload ]
end


# check out the source
# git clone https://github.com/discourse/discourse.git .

# bundle install
# rake db:migrate
# rake db:seed_fu
# redis-cli flushall
# thin start 