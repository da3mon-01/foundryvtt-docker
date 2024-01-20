#!/bin/bash
# Support docker secret mount feature

set -e

export OPTIONS_FILE="${FOUNDRY_DATA}/Config/options.json"

if [[ -n "$1" ]]; then 
    exec "$@";
else
    if [[ -f "$FOUNDRY_ADMIN_PASSWORD_FILE" ]];then
      echo "Found Password file, loading admin credential from there";
      export FOUNDRY_ADMIN_PASSWORD=$(cat $VTT_ADMIN_PASSWORD_FILE) &>/dev/null;
    fi

    exec node ${FOUNDRY_HOME}/resources/app/main.js --dataPath=${FOUNDRY_DATA} --adminPassword=${VTT_ADMIN_PASSWORD} --port=${VTT_PORT}
fi
