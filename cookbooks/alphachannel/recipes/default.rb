#
# Cookbook Name:: alphachannel
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute "update-upgrade" do
  command "apt-get update && apt-get upgrade -y"
  action :run
end

execute "sudo apt-get install git -y"
execute "sudo apt-get install libpq-dev nodejs -y"

user = node["alphachannel"]["user"]

group "#{user}"

user "#{user}" do
    comment "Deployment user for capistrano"
    action :create
    home "/home/#{user}"
    shell '/bin/bash'
    group "#{user}"
    password "password"
    manage_home true
    system true
end

directory "home/#{user}/.ssh" do
  owner "#{user}"
  group "#{user}"
  mode 0700
  action :create
end

# TODO: Auto configure ssh keys

group 'sudo' do
    members 'deploy'
    action :modify
end

bash 'configure_ufw' do
    code <<-EOH
        sudo ufw allow ssh
        sudo allow 4444/tcp
        sudo allow 80/tcp
        sudo allow 443/tcp
        sudo allow 25/tcp
        sudo ufw enable
    EOH
end

bash 'git_n_capt' do
  code <<-EOH
    ssh -T git@github.com
    if [ -e /home/#{user}/.ssh/github ]
    then
      ssh-keygen -t rsa -f /home/#{user}/.ssh/github -y
    else
      ssh-keygen -t rsa -f /home/#{user}/.ssh/github
    fi
  EOH
end

cookbook_file "/etc/init/god.conf" do
  source "upstart_god.conf"
  mode 0644
  owner 'root'
  group 'root'
end

path = "/home/#{user}/apps/#{node['alphachannel']['app_name']}/shared/config"
directory path do
  owner "#{user}"
  group "#{user}"
  mode 0700
  action :create
  only_if { Dir.exists?("/home/#{user}/apps/#{node['alphachannel']['app_name']}/shared") }
end

template "#{path}/database.yml" do
  source "database.yml.erb"
  mode 0640
  owner "#{user}"
  group "#{user}"
  only_if { Dir.exists?(path) }
end
