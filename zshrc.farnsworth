# start/stop mysql
function start_mysql { cd /opt/local ; sudo -b /opt/local/lib/mysql5/bin/mysqld_safe ; cd - }
function stop_mysql { sudo /opt/local/bin/mysqladmin5 -u root shutdown }

function start_postgres { sudo -u postgres /opt/local/lib/postgresql83/bin/postgres -D /opt/local/var/db/postgresql83/defaultdb }

function start_mongodb { sudo /opt/local/bin/mongod -f /opt/local/etc/mongo/mongodb.conf }

function unifi_server {
  echo Starting unifi server, access at https://localhost:8443/login?url=/manage
  echo ctrl-c to stop it ...
  java -jar /Applications/UniFi.app/Contents/Resources/lib/ace.jar start
}
