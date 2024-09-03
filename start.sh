#!/bin/sh

set -e

# Load environment variables from stage.env file if it exists
if [ -f /etc/secrets/stage.env ]; then
    echo "Loading environment variables from stage.env"
    export $(cat /etc/secrets/stage.env | grep -v '^#' | xargs)
else
    echo "Warning: stage.env file not found!"
fi

echo "start the app"
exec "$@"