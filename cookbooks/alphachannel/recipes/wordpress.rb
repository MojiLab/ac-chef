mysqlpass = data_bag_item("mysql", "rtpass.json")
node.default["wordpress"]["db"]["root_password"] = mysqlpass["password"]
node.default["wordpress"]["parent_dir"] = "/home/#{node["alphachannel"]["user"]}/apps"
node.default['apache']['default_site_port'] = '8080'

include_recipe "wordpress::default"

=begin
bash "backup wordpress" do
  code <<-EOH
    #!/bin/bash

    # Set the date format, filename and the directories where your backup files will be placed and which directory will be archived.
    NOW=$(date +"%Y-%m-%d-%H%M")
    FILE="wordpressrestore.$NOW.tar"
    BACKUP_DIR="/home/#{node["alphachannel"]["user"]}/_backup"
    WWW_DIR="/var/www"

    # MySQL database credentials
    DB_USER="root"
    DB_PASS=#{mysqlpass}
    DB_NAME="wordpress"
    DB_FILE="wordpressrestore.$NOW.sql"

    # dump the wordpress dbs
    mysql -u$DB_USER -p$DB_PASS --skip-column-names -e "select table_name from information_schema.TABLES where TABLE_NAME like 'wp_%';" | xargs mysqldump     --add-drop-table -u$DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_FILE

    # archive the website files
    tar -cvf $BACKUP_DIR/$FILE $WWW_DIR

    # append the db backup to the archive
    tar --append --file=$BACKUP_DIR/$FILE $BACKUP_DIR/$DB_FILE

    # remove the db backup
    rm $BACKUP_DIR/$DB_FILE

    # compress the archive
    gzip -9 $BACKUP_DIR/$FILE

    # pull in the backup to a temp dir
    mkdir /tmp/restore

    # untar and expand it
    cd /tmp/restore
    tar -zxvf /var/blog_backup/<yoursite>.*.tar.gz

    # copy the website files to the wordpress site root
    sudo cp -Rf /tmp/restore/var/www/wordpress/* /home/#{node["alphachannel"]["user"]}/apps
  EOH
end
=end
