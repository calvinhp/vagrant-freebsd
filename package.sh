#!/bin/sh
VBoxManage modifyvdi $HOME/'VirtualBox VMs/FreeBSD 9.2 i386/FreeBSD 9.2 i386'.vdi compact
vagrant package --base 'FreeBSD 9.2 i386' --output freebsd-9.2-i386.box
