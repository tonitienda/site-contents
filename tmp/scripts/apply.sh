#! /bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color


CURRENT_COLOR=$(curl -s http://localhost/status | jq -r .color)

if [ -z "$CURRENT_COLOR" ]; then
    # If CURRENT_COLOR is empty (no application is running), start with blue
    NEXT_COLOR="blue"
    NEXT_PORT="8081"
elif [ "$CURRENT_COLOR" = "blue" ]; then
    # If current is blue, next is green
    NEXT_COLOR="green"
    NEXT_PORT="8082"
elif [ "$CURRENT_COLOR" = "green" ]; then
    # If current is green, next is blue
    NEXT_COLOR="blue"
    NEXT_PORT="8081"
else
    echo -e "Color not supported $CURRENT_COLOR"
    exit 1
fi

echo -e "$BLUE Deploying $NEXT_COLOR on port $NEXT_PORT $NC"

sudo mkdir -p /app/
sudo chown ubuntu:ubuntu /app/

pkill -f /app/$NEXT_COLOR || true

mv bluegreendemo /app/$NEXT_COLOR
chmod +x /app/$NEXT_COLOR

# Start the application in background
echo "Starting /app/$NEXT_COLOR on port $NEXT_PORT"
nohup /app/$NEXT_COLOR --port $NEXT_PORT --color $NEXT_COLOR &

# Give it a moment to start
sleep 2

NEXT_COLOR_CHECK=$(curl -s http://localhost:$NEXT_PORT/status | jq -r .color)

if [ "$NEXT_COLOR_CHECK" != "$NEXT_COLOR" ]; then
    echo -e "$RED Deployment failed! $NEXT_COLOR did not start correctly $NC"
    exit 1
fi

sudo mv *.conf /etc/nginx/
sudo ln -sf /etc/nginx/$NEXT_COLOR.conf /etc/nginx/upstream.conf
sudo nginx -s reload

sleep 1

CURRENT_COLOR=$(curl -s http://localhost/status | jq -r .color)

if [ "$CURRENT_COLOR" = "$NEXT_COLOR" ]; then
    echo -e "$GREEN Deployment successful! Current color is now $CURRENT_COLOR $NC"
    exit 0
else
    echo -e "$RED Deployment failed! Current color is still $CURRENT_COLOR $NC"
    exit 1
fi