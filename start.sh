#!/bin/sh

set -e

# Load environment variables from stage.env file if it exists
if [ -f /app/stage.env ]; then
    export $(cat /app/stage.env | grep -v '^#' | xargs)
fi

echo "start the app"
exec "$@"