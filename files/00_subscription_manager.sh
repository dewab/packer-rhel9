#!/usr/bin/env bash

set -e
set -o pipefail

# Check to see if system is running on Azure
if yum repolist rhui-microsoft-azure-rhel9 --enabled | grep -q "Azure"; then
    echo "System is running on Azure -- not registering."
    exit 0
fi

# Check if REDHAT_USERNAME and REDHAT_PASSWORD are set
if [[ -n "$REDHAT_USERNAME" && -n "$REDHAT_PASSWORD" ]]; then
    echo "Attempting to register using username and password..."
    subscription-manager register --username "${REDHAT_USERNAME}" --password "${REDHAT_PASSWORD}"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to register using username and password."
        exit 1
    fi
elif [[ -n "$REDHAT_REGISTRATION_COMMAND" ]]; then
    echo "Running registration command..."
    eval $REDHAT_REGISTRATION_COMMAND
    if [ $? -ne 0 ]; then
        echo "Error: Registration command failed."
        exit 1
    fi
else
    echo "Error: Do not have username, password, or registration command configured."
    exit 1
fi
