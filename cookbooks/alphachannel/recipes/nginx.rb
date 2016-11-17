package "nginx"

default_path = "/etc/nginx/sites-enabled/default"
execute "rm -f #{default_path}" do
  only_if { File.exists?(default_path) }
end

service "nginx" do
  supports [:status, :restart]
  action :start
end

execute "chown-sites-enabled" do
  command "chown -R #{default['user']}:deploy /etc/nginx/sites-enabled"
  user "root"
end

nginx_config_path = "/home/#{default["user"]}/apps/#{default['app_name']}/current/config/nginx.conf"
execute "symlink-nginx" do
  command "ln -nfs #{nginx_config_path} '/etc/nginx/sites-enabled/#{default['app_name']}'"
  only_if { File.exists?(nginx_config_path) }
end
