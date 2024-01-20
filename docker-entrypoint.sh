#!/bin/bash
# Support docker secret mount feature

set -e

export OPTIONS_FILE="${FOUNDRY_DATA}/Config/options.json"

if [[ -n "$1" ]]; then 
    exec "$@";
else
    if [[ -f "$FOUNDRY_ADMIN_PASSWORD_FILE" ]];then
      echo "Found Password file, loading admin credential from there";
      export FOUNDRY_ADMIN_PASSWORD=$(cat $FOUNDRY_ADMIN_PASSWORD_FILE) &>/dev/null;
    fi

    if [[ -f "$FOUNDRY_OPTIONS_FILE" ]];then
        echo "Found options file in secrets, copying to datadir";
        cp $CP_COMMAND_ARG $FOUNDRY_OPTIONS_FILE $OPTIONS_FILE;
    fi
    echo "Options file contents:"
    cat $OPTIONS_FILE

    exec node ${FOUNDRY_HOME}/resources/app/main.js --dataPath=${FOUNDRY_DATA} --adminPassword=${FOUNDRY_ADMIN_PASSWORD} --port=${FOUNDRY_PORT}
fi
