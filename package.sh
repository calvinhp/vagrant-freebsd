#!/bin/sh
VBoxManage modifyvdi $HOME/'VirtualBox VMs/FreeBSD 9.2/FreeBSD 9.2'.vdi compact
vagrant package --base 'FreeBSD 9.2' --output freebsd-9.2.box
