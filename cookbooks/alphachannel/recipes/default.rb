#
# Cookbook Name:: alphachannel
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

execute "update-upgrade" do
  command "apt-get update && apt-get upgrade -y"
  action :run
end

user = node["alphachannel"]["user"]

include_recipe 'alphachannel::ffmpeg'

group "#{user}"

user "#{user}" do
    comment "Deployment user for capistrano"
    action :create
    home "/home/#{user}"
    shell '/bin/bash'
    group "#{user}"
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

include_recipe 'alphachannel::nginx'

bash 'configure_ufw' do
    code <<-EOH
        sudo ufw allow ssh
        allow 4444/tcp
        allow 80/tcp
        allow 443/tcp
        allow 25/tcp
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
  source "upstart_god.rb"
  mode 0644
  owner 'root'
  group 'root'
end

path = "/home/#{user}/apps/#{node['alphachannel']['app_name']}/shared/config"
template "#{path}/database.yml" do
  source "database.yml.erb"
  mode 0640
  owner "#{user}"
  group "#{user}"
  only_if { Dir.exists?(path) }
end
