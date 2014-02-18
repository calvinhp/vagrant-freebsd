#!/bin/sh
VBoxManage modifyvdi $HOME/'VirtualBox VMs/vagrant-freebsd-10/vagrant-freebsd-10'.vdi compact
vagrant package --base 'vagrant-freebsd-10' --output vagrant-freebsd-10.box
