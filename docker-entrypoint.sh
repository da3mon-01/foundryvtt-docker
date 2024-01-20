#!/bin/bash
# Support docker secret mount feature

set -e

export CONFIG_DIR="${FOUNDRY_DATA}/Config"
export OPTIONS_FILE="${CONFIG_DIR}/options.json"

if [[ -n "$1" ]]; then 
    exec "$@";
else
    if [[ -f "$FOUNDRY_ADMIN_PASSWORD_FILE" ]];then
      echo "Found Password file, loading admin credential from there";
      export FOUNDRY_ADMIN_PASSWORD=$(cat $FOUNDRY_ADMIN_PASSWORD_FILE) &>/dev/null;
    fi

    if [[ -f "$FOUNDRY_OPTIONS_FILE" ]];then

        if [[ ! -d "${CONFIG_DIR}" ]];then
          echo "${CONFIG_DIR} does not exist, creating...";
          mkdir -p ${CONFIG_DIR};
        fi

        echo "Found options file in secrets, copying to datadir";
        cp $CP_COMMAND_ARG $FOUNDRY_OPTIONS_FILE $OPTIONS_FILE;
    fi
    echo "Options file contents:"
    cat $OPTIONS_FILE

    exec node ${FOUNDRY_HOME}/resources/app/main.js --dataPath=${FOUNDRY_DATA} --adminPassword=${FOUNDRY_ADMIN_PASSWORD} --port=${FOUNDRY_PORT}
fi
