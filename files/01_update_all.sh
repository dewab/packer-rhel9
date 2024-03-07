#!/usr/bin/env bash

# Update all packages
if ! yum --assumeyes update ; then
    echo "yum update failed" >&2
    exit 1
fi
