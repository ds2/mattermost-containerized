#!/usr/bin/env bash

MM_SERVER_URL='http://localhost:16020/'

echo "$(date): waiting for server to come up.."
SERVER_UP=1
for i in $(seq 1 90); do
    curl -o /dev/null -L $MM_SERVER_URL 2>>test-server.log
    RC=$?
    if [[ $RC -gt 0 ]]; then
        echo -n "."
        sleep 2
    else
        echo "works"
        SERVER_UP=0
        break
    fi
done

if [[ $SERVER_UP -eq 0 ]]; then
    echo "$(date): is running"
else
    echo "$(date): looks like there are startup issues. Please check log"
    docker-compose -f container-compose.yaml logs --tail=40
    echo "test-server log from curl is here:"
    cat test-server.log
    exit 1
fi
