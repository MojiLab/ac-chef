name "staging"
description "The master staging branch"
default_attributes "alphachannel" => { "db" => { "host" => "amiowfl1dis74a.chwwxm9ckx0l.us-west-2.rds.amazonaws.com", "name" => "ac_staging", "username" => "deploy", "port" => "5432", "password" => "password" } }
