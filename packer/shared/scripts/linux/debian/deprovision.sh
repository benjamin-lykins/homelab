#!/bin/bash -ex

# This script deprovisions a Linux system by performing the following tasks:
# 1. Sets the DEBIAN_FRONTEND environment variable to noninteractive to suppress prompts during package operations.
# 2. Cleans various log files:
#    - /var/log/audit/audit.log
#    - /var/log/wtmp
#    - /var/log/lastlog
# 3. Removes persistent udev rules for network interfaces.
# 4. Cleans the /tmp and /var/tmp directories.
# 5. Removes SSH host keys to ensure new keys are generated on next boot.
# 6. Cleans the machine-id and re-creates the symlink for /var/lib/dbus/machine-id.
# 7. Clears the shell history for both the current user and root.
# 8. Truncates the hostname, hosts, and resolv.conf files and sets the hostname to "localhost".

export DEBIAN_FRONTEND=noninteractive

# Cleaning logs.
echo "Cleaning logs..."
if [ -f /var/log/audit/audit.log ]; then
    echo "Cleaning audit logs..."
    cat /dev/null >/var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    echo "Cleaning wtmp logs..."
    cat /dev/null >/var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    echo "Cleaning lastlog logs..."
    cat /dev/null >/var/log/lastlog
fi

# Cleaning udev rules.
echo "Cleaning udev rules..."
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    echo "Cleaning persistent net rules..."
    rm /etc/udev/rules.d/70-persistent-net.rules
fi

# Cleaning the /tmp directories
echo "Cleaning /tmp directories..."
rm -rf /tmp/*
rm -rf /var/tmp/*

# Cleaning the SSH host keys
echo "Cleaning SSH host keys..."
rm -f /etc/ssh/ssh_host_*

# Cleaning the machine-id
echo "Cleaning machine-id..."
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Cleaning the shell history
echo "Cleaning shell history..."
unset HISTFILE
history -cw
echo >~/.bash_history
rm -fr /root/.bash_history

# Truncating hostname and hosts and setting hostname to localhost
echo "Cleaning hostname, and hosts; setting hostname to localhost..."
truncate -s 0 /etc/{hostname,hosts}
hostnamectl set-hostname base
