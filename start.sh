#!/bin/sh

set -e

echo "run db migration"
source /app/app.env
echo $CORE_ENVIRONMENT
if [ $CORE_ENVIRONMENT == "local" ]
    then /app/migrate -path /app/migration -database "${DB_SOURCE_DEV}" -verbose up
    else /app/migrate -path /app/migration -database "${DB_SOURCE}" -verbose up
fi

echo "start the app"
exec "$@"