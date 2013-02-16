# Note that all external recipes required in here also need to be in metadata.rb

package "git-core"
package "zsh"
package "vim"

############ RUBY ##################

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby "1.9.3-p385"

############ GEMS ###################

gem_package "bundler"
gem_package "bluepill"

########### SET UP USER ###########

user node[:user][:name] do
  password node[:user][:password]
  gid "sudo"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/zsh"
end

template "/etc/sudoers" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
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

########### REDIS ################

include_recipe "redis::source"

######## POSTGRES #############

package "postgresql-contrib-9.1"

package "postgresql-server-dev-9.1"

include_recipe "postgresql::server"

include_recipe "database::postgresql"

postgresql_connection_info = {:host => "127.0.0.1",
                              :port => node['postgresql']['config']['port'],
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

postgresql_database 'discourse' do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user "deploy" do
  connection postgresql_connection_info
  password node['postgresql']['password']['deploy']
  template 'template0'
  encoding "utf8"
  action :create
end

# Add hstore
postgresql_database "discourse" do
  connection postgresql_connection_info
  sql "CREATE EXTENSION hstore;"
  action :query
end

postgresql_database_user "deploy" do
  connection postgresql_connection_info
  database_name 'discourse'
  privileges [:all]
  action :grant
end

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