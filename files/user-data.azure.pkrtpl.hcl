#cloud-config

package_update: true
package_upgrade: true
packages:
  - zsh
  - nginx

timezone: ${guest_timezone}

users:
  - default
  - name: "${guest_username}"
    sudo: ALL=(ALL) NOPASSWD:ALL
    primary_group: "${guest_username}"
    groups: users, admin
    shell: /bin/bash
    lock_passwd: false
    passwd: "${guest_password}"
  - name: "testuser"
    sudo: ALL=(ALL) NOPASSWD:ALL
    primary_group: "testuser"
    groups: users, admin
    shell: /bin/bash
    lock_passwd: false
    passwd: "${guest_password}"
