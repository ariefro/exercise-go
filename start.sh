#!/bin/sh

set -e

# Load environment variables from staging.env file if it exists
if [ -f /app/staging.env ]; then
    echo "Loading environment variables from staging.env"
    export $(cat /app/staging.env | grep -v '^#' | xargs)
else
    echo "Warning: staging.env file not found!"
fi

echo "start the app"
exec "$@"