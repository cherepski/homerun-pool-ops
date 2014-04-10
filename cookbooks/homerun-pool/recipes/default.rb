#
# Cookbook Name:: homerun_pool
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

apache_module "wsgi" do
    enable true
end

yum_package "git" do
    action :install
end

web_app "homerun-pool" do
    server_name node['homerun_pool']['name']
    domain_name node['homerun_pool']['hostname']
    docroot node['homerun_pool']['home']
    project node['homerun_pool']['project']
end

python_virtualenv node['homerun_pool']['env'] do
    interpreter "python2.6"
    owner "root"
    group "root"
    action :create
end

postgresql_database node['homerun_pool']['database'] do
    connection ({:host => node['homerun_pool']['database_host'], :port => node['postgresql']['config']['port'], :username => node['homerun_pool']['database_username'], :password => node['postgresql']['password']['postgres']})
    action :create
end

postgresql_connection_info = {:host => node['homerun_pool']['database_host'], :port => node['postgresql']['config']['port'], :username => node['homerun_pool']['database_username'], :password => node['postgresql']['password']['postgres']}

postgresql_database_user node['homerun_pool']['database_user'] do
    connection postgresql_connection_info
    password node['homerun_pool']['database_user_password']
    action :create
end

postgresql_database_user node['homerun_pool']['database_user'] do
    connection postgresql_connection_info
    database_name node['homerun_pool']['database']
    privileges [:all]
    action :grant
end

execute "install_requirements" do
    user "root"
    command "#{node['homerun_pool']['env']}/bin/pip install -r #{node['homerun_pool']['home']}/requirements.txt"
end

execute "django_syncdb" do
    user "root"
    command "#{node['homerun_pool']['env']}/bin/python #{node['homerun_pool']['home']}/#{node['homerun_pool']['project']}/manage.py syncdb --noinput"
end

#execute "django_migrate" do
#    user "root"
#    command "#{node['homerun_pool']['env']}/bin/python #{node['homerun_pool']['home']}/#{node['homerun_pool']['project']}/manage.py migrate --noinput"
#end

#execute "collect_static" do
#    user "root"
#    command "#{node['homerun_pool']['env']}/bin/python #{node['homerun_pool']['home']}/#{node['homerun_pool']['project']}/manage.py collectstatic --noinput"
#end

#mysql_database_user node['homerun_pool']['database_user'] do
#    connection mysql_connection_info
#    password node['homerun_pool']['database_user_password']
#    host '%'
#    action :grant
#end

execute "iptables -I INPUT -p tcp --dport 80 -j ACCEPT" do
    user "root"
end

execute "iptables -I INPUT -p tcp --dport 8080 -j ACCEPT" do
    user "root"
end

execute "iptables -I INPUT -p tcp --dport 3306 -j ACCEPT" do
    user "root"
end

template "#{node['homerun_pool']['vagrant_user']}/.bash_profile" do
    source "bash_profile.erb"
    mode "644"
    owner "vagrant"
    group "vagrant"
end
