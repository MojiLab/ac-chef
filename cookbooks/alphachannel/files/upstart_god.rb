# god upstart service
description "God process monitoring"
author "Josh Siegel <josh@alphachannel.cc>"
usage "..."

start on runlevel [2345]
stop on runlevel [016]

env RAILS_ENV=production
env RAILS_ROOT=/home/deploy/apps/alphachannel/current
env HOME=/home/deploy

chdir /home/deploy/apps/alphachannel/current

setuid deploy
setgid deploy

respawn
respawn limit 10 60

console log

pre-start script

end script

exec /usr/local/rvm/bin/rvm default do bundle exec god -D -c config/app.god -l log/god.log
