name "default"
description "A role to configure initial user setup"
run_list "recipe[alphachannel::default]", "recipe[cron-delvalidate::default]"
default_attributes
