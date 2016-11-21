mysqlpass = data_bag_item("mysql", "rtpass.json")
node.override["wordpress"]["db"]["root_password"] = mysqlpass["password"]
node.override["wordpress"]["parent_dir"] = "/home/#{node["alphachannel"]["user"]}/apps"
node.override['wordpress']['dir'] = "/home/#{node["alphachannel"]["user"]}/apps/wordpress"
node.override['wordpress']['db']['pass'] = "password"
node.override['apache']['default_site_port'] = '8080'
node.override['wordpress']['server_port'] = '8080'
node.override['apache']['listen']            = ['*:8080']
node.override['apache']['user'] = node["alphachannel"]["user"]

execute "sudo apt-get install php5-fpm php5-mysql -y"

include_recipe "wordpress::default"
