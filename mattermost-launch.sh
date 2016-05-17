#!/bin/bash -x

DB_HOST=${DB_HOST:-db}
DB_PORT_5432_TCP_PORT=${DB_PORT_5432_TCP_PORT:-5432}

echo -ne "Configure MySQL database connection..."
sed -Ei "s/DB_HOST/$DB_HOST/" /opt/mattermost/config/config.json
sed -Ei "s/DB_PORT/$DB_PORT_5432_TCP_PORT/" /opt/mattermost/config/config.json
sed -Ei "s/MM_USERNAME/$MM_USERNAME/" /opt/mattermost/config/config.json
sed -Ei "s/MM_PASSWORD/$MM_PASSWORD/" /opt/mattermost/config/config.json
sed -Ei "s/MM_DBNAME/$MM_DBNAME/" /opt/mattermost/config/config.json
echo "done"

exec /opt/mattermost/bin/platform
