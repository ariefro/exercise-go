#!/bin/sh

set -e

# load environment variables from app.env file
if [ -f /app/app.env ]; then
    export $(cat /app/app.env | xargs)
fi

echo "run db migration"
echo $CORE_ENVIRONMENT

if [ $CORE_ENVIRONMENT = "local" ]
    then /app/migrate -path /app/migration -database "${DB_SOURCE_DEV}" -verbose up
    else /app/migrate -path /app/migration -database "${DB_SOURCE}" -verbose up
fi

echo "start the app"
exec "$@"