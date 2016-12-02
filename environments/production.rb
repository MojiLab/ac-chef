name "production"
description "The master production branch"
default_attributes "alphachannel" => { "db" => { "host" => "ampsju0945wrcq.chwwxm9ckx0l.us-west-2.rds.amazonaws.com", "name" => "ac_prod", "username" => "deploy", "port" => "5432", "password" => "password" } }
