#!/bin/bash -x

DB_HOST=${DB_HOST:-mysql}
DB_PORT_3306_TCP_PORT=${DB_PORT_3306_TCP_PORT:-3306}
MM_USERNAME=${DB_USER:-mmuser}
MM_PASSWORD=${DB_PASSWORD:-mostest}
MM_DBNAME=${DB_DATABASE:-mattermost_test}

echo -ne "Configure MySQL database connection..."
sed -e 's#"DataSource": "mmuser:mostest@tcp(mysql:3306)/mattermost_test?charset=utf8mb4,utf8"#"DataSource": "'"$DB_USER:$DB_PASSWORD@tcp($DB_HOST:$DB_PORT_3306_TCP_PORT)/$DB_DATABASE?charset=utf8mb4,utf8"'"#' \
    /opt/mattermost/config/config.json > /tmp/config.json

cat /tmp/config.json >/opt/mattermost/config/config.json
echo "done"

exec /opt/mattermost/bin/platform
