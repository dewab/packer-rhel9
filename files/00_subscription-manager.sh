#!/usr/bin/env bash

set -x

# Check to see if system is running on Azure
yum repolist rhui-microsoft-azure-rhel9 --enabled | grep Azure && IsAzure=Yes || IsAzure=No

if [ "$IsAzure" == "Yes" ]; then
    echo "System is running on Azure -- not registering."
    exit 0
fi

# Register the system
if ! subscription-manager register --username "${REDHAT_USERNAME}" --password "${REDHAT_PASSWORD}"; then
    echo "Error: Failed to register the system."
    exit 1
fi
