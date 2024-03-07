#!/usr/bin/env bash

# Check to see if system is running on Azure
yum repolist rhui-microsoft-azure-rhel9 --enabled | grep Azure && IsAzure=Yes || IsAzure=No

# Unregister the system, if not running on Azure
if [ "$IsAzure" == "No" ]; then
    subscription-manager unregister
    subscription-manager clean
fi

# Clean Up Systemd Temp Files
systemd-tmpfiles --clean
systemd-tmpfiles --remove

# Run Azure Tools Deprovision Script
if [ -x "/usr/sbin/waagent" ]; then
    /usr/sbin/waagent -force -deprovision+user
fi

find /var/cache -type f -exec rm -rvf {} \;
find /var/log -type f -exec truncate --size=0 {} \;
truncate -s 0 /etc/machine-id

# Remove files used for image creation
rm -rvf /tmp/* /var/tmp/*
rm -vf /var/lib/systemd/random-seed
rm -vf /root/.wget-hsts
# rm -vf /etc/ssh/*_key /etc/ssh/*_key.pub
rm -vf ~/.*history

# Truncate the history file
export HISTSIZE=0

# Sync the file system
sync
