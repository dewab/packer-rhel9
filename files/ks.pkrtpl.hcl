# Accept EULA
eula --agreed

# Keyboard layouts
keyboard ${guest_keyboard}

# Root password
rootpw ${admin_password}

# System language
lang ${guest_language}

# Firewall configuration
firewall --enabled --ssh

# System authorization information
# auth  --useshadow  --passalgo=sha512

# Use text mode install
text

# SELinux configuration
selinux --enforcing

# Do not configure the X Window System
skipx

# Use CDROM Installation method
cdrom

# Register to Red Hat
# rhsm --organization=1714986 --activation-key="homelab" --connect-to-insights

# Set purpose
syspurpose --role="Red Hat Enterprise Linux Server" --usage=test

# Network information
network  --bootproto=dhcp --device=eth0

# Reboot after installation
reboot

# System timezone
timezone ${guest_timezone} 
timesource --ntp-pool pool.ntp.org

# System bootloader configuration
bootloader --location=mbr --append="net.ifnames=0 biosdevname=0"

# Clear the Master Boot Record
zerombr

# Partition clearing information
clearpart --all --initlabel --drives=sda

## Disk partitioning information ##
# Add Boot Automagically
reqpart --add-boot

# Hard partitioning
#part / --asprimary --fstype="xfs" --grow --size=1
#part swap --asprimary --fstype="swap" --size=2048

# LVM partitioning
part pv.01 --fstype="lvmpv" --ondisk=sda --size=1 --grow
volgroup rhel --pesize=4096 pv.01
logvol none  --fstype="None" --size=1 --grow --thinpool --metadatasize=4 --chunksize=65536 --name=pool00 --vgname=rhel
logvol / --fstype="xfs" --size=8192 --thin --poolname=pool00 --name=root --vgname=rhel
logvol swap --fstype="swap" --size=2048 --thin --poolname=pool00 --name=swap --vgname=rhel
logvol /var --fstype="xfs" --size=4096 --thin --poolname=pool00 --name=var --vgname=rhel --fsoptions="nodev"
logvol /var/log --fstype="xfs" --size=2048 --thin --poolname=pool00 --name=var_log --vgname=rhel --fsoptions="nodev"
logvol /var/log/audit --fstype="xfs" --size=512 --thin --poolname=pool00 --name=var_log_audit  --vgname=rhel --fsoptions="nodev"
logvol /var/tmp --fstype="xfs" --size=4096 --thin --poolname=pool00 --name=var_tmp --vgname=rhel --fsoptions="nodev,noexec,nosuid"
logvol /tmp --fstype="xfs" --size=4096 --thin --poolname=pool00 --name=tmp --vgname=rhel --fsoptions="nodev,noexec,nosuid"
logvol /home --fstype="xfs" --size=2048 --thin --poolname=pool00 --name=home --vgname=rhel --fsoptions="nodev"
## End Disk partitioning information ##

# Enable KDump
%addon com_redhat_kdump --disable
%end

## USERS

# Add Local Users
#user --name=${guest_username} --gecos="User" --shell=/usr/bin/zsh --groups=wheel --homedir=/home/${guest_username} --iscrypted --password=${guest_password_encrypted}
user --name=${guest_username} --gecos="User" --shell=/usr/bin/zsh --groups=wheel --homedir=/home/${guest_username} --password=${guest_password}

# Add SSH keys to local users
sshkey --user=root  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFaiZxQuPBgezB4eeFcYfFHy3Du6KvwFvdWqx5QsMNqC Daniel@snotra.viking.org"
sshkey --user=root  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAge61e/yBUzGqAjtPpmcFd6ptOkjQuPN+A0L086LgG8 daniel@sunna.viking.org"
sshkey --user=root  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHY9ElZqwcAwOtQmrCK6iBLtajwLoiW4s23OwIcyq08z heimdall@bifrost.viking.org"

## END USERS

## Software
%packages
open-vm-tools
dnf-utils
ipa-client
realmd
adcli
bind-utils
sg3_utils
tmux
autofs
vim
zsh
git
lsof
tcpdump
nmap-ncat
nmap
mlocate
net-tools
iperf3
#cloud-init
%end

%post --log=/root/ks-post.log
# Allow for NFS home directories
/usr/sbin/setsebool -P use_nfs_home_dirs=1

# Add ansible to local sudoers with NOPASSWD
cat <<EOF > /etc/sudoers.d/ansible.conf
ansible   ALL=(ALL) NOPASSWD: ALL
EOF
cat <<EOF > /etc/sudoers.d/${guest_username}.conf
${guest_username}   ALL=(ALL) NOPASSWD: ALL
EOF
%end
