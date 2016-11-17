#
# Cookbook Name:: alphachannel
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'ffmpeg'
include_recipe 'alphachannel::nginx'

execute "apt-get update"

group "deploy"

user 'deploy' do
    comment "Deployment user for capistrano"
    action :create
    home '/home/deploy'
    shell '/bin/bash'
    group "deploy"
    manage_home true
    system true
end

directory '~/.ssh' do
    owner 'root'
    mode '0700'
    action :create
end

group 'sudo' do
    members 'deploy'
    action :modify
end

bash 'configure_ufw' do
    code <<- EOH
        sudo ufw allow ssh
        allow 4444/tcp
        allow 80/tcp
        allow 443/tcp
        allow 25/tcp
        sudo ufw enable
    EOH
end

bash 'git_n_capt' do
    ssh -T git@github.com
    ssh-keygen -t rsa -f github.pub
end

cookbook_file "/etc/init/god.conf" do
  source "upstart_god"
  mode 0644
  owner 'root'
  group 'root'
end

path = "/home/#{default['user']}/apps/#{default['app_name']}/shared/config"
template "#{path}/database.yml" do
  source "database.yml.erb"
  mode 0640
  owner default['user']
  group default['user']
end
