#!/bin/sh

set -e

################################################################################
# CONFIG
################################################################################

# Packages which are pre-installed
INSTALLED_PACKAGES="bash zsh sudo py27-salt ca_root_nss"
# If you want really minimal box - remove virtualbox-ose-additions as it
# pulls in X server and libraries, and also Python.

# Configuration files
MAKE_CONF="https://raw.github.com/calvinhp/vagrant-freebsd/master/etc/make.conf"
RC_CONF="https://raw.github.com/calvinhp/vagrant-freebsd/master/etc/rc.conf"
LOADER_CONF="https://raw.github.com/calvinhp/vagrant-freebsd/master/boot/loader.conf"
PKG_REPOS_CONF="https://raw.github.com/calvinhp/vagrant-freebsd/master/etc/pkg_repos.conf"

# Message of the day
MOTD="https://raw.github.com/calvinhp/vagrant-freebsd/master/etc/motd"

# Private key of Vagrant (you probable don't want to change this)
VAGRANT_PUBLIC_KEY="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"

################################################################################
# SYSTEM UPDATE
################################################################################

#sed 's/\[ ! -t 0 \]/false/' /usr/sbin/freebsd-update >/tmp/freebsd-update
#chmod +x /tmp/freebsd-update
PAGER=/bin/cat freebsd-update fetch
PAGER=/bin/cat sh -c 'freebsd-update install || exit 0'
#rm /tmp/freebsd-update

################################################################################
# PACKAGE INSTALLATION
################################################################################

# make.conf
fetch --no-verify-peer -o /etc/make.conf $MAKE_CONF

# Setup pkgng
# pkgng has a sample conf file, salt needs it to detect we are using pkgng
cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg.conf
mkdir -p /usr/local/etc/pkg/repos
fetch --no-verify-peer -o /usr/local/etc/pkg/repos/vagrant_repos.conf $PKG_REPOS_CONF
# bootstrap latest pkgng without pkg_ tools that aren't in FreeBSD >= 10
ASSUME_ALWAYS_YES=YES pkg bootstrap
pkg update
pkg upgrade -y
# Install required packages
pkg install -y $INSTALLED_PACKAGES
# Install our VBox additions with no X11 deps
pkg install -y -r sixfeetup virtualbox-ose-additions

################################################################################
# Configuration
################################################################################

# Create the vagrant user
pw useradd -n vagrant -s /usr/local/bin/bash -m -G wheel -h 0 <<EOP
vagrant
EOP

# Enable sudo for this user
echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# Authorize vagrant to login without a key
mkdir -p /home/vagrant/.ssh
# Get the public key and save it in the `authorized_keys`
fetch --no-verify-peer -o /home/vagrant/.ssh/authorized_keys $VAGRANT_PUBLIC_KEY
chown -R vagrant:vagrant /home/vagrant/.ssh

fetch --no-verify-peer -o /etc/rc.conf $RC_CONF
fetch --no-verify-peer -o /boot/loader.conf $LOADER_CONF
fetch --no-verify-peer -o /etc/motd $MOTD

# Symlink the root CAs to /etc/ssl/cert.pem so we can use fetch
ln -s /usr/local/share/certs/ca-root-nss.crt /etc/ssl/cert.pem

################################################################################
# CLEANUP
################################################################################

# Remove binary package archives
rm -rf /var/cache/pkg/*

# Remove the history
cat /dev/null >/root/.history

# Empty out tmp directory
rm -rf /tmp/*

# Truncate log files
for log in $(find /var/log -type f); do cat /dev/null >$; done

# Try to make it even smaller
while true; do
    read -p "Would you like me to zero out all data to reduce box size? [y/N] " yn
    case $yn in
        [Yy]* ) dd if=/dev/zero of=/tmp/ZEROES bs=1M; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# DONE!
echo "We are all done. Poweroff the box and package it up with Vagrant."
