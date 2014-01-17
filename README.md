# FreeBSD on Vagrant

I use [FreeBSD] but it's a bit of work to get it running on [Vagrant].
With this Vagrant box you'll get a FreeBSD 9.2 on ZFS in one step.

<img src="http://www.freebsd.org/layout/images/logo-red.png" margin-top="0.5em" />

**Table of Contents**

- [FreeBSD on Vagrant](#freebsd-on-vagrant)
	- [Quickstart](#quickstart)
	- [Create your own FreeBSD Box](#create-your-own-freebsd-box)
		- [VirtualBox Settings](#virtualbox-settings)
		- [Installation from FreeBSD ISO](#installation-from-freebsd-iso)
		- [Configuration](#configuration)
		- [Package for Vagrant](#package-for-vagrant)
	- [Credits](#credits)
	- [License](#license)

## Quickstart

Simply copy the [Vagrantfile] from this repository to the project you want to
run the VM from and you are done. The box will be downloaded for you.
The root password is vagrant.

## Create your own FreeBSD Box

This is for people who want to have their own customized box, instead of the
box I made for you with the scripts in this repository.

The FreeBSD box is built from the stock FreeBSD ISO image, namely the
[9.2-RELEASE-i386] disc1 ISO. Download this ISO and create a new virtual machine.

### VirtualBox Settings

VirtualBox works best with the following settings:

- System -> Motherboard -> **Hardware clock in UTC time**
- System -> Acceleration -> **VT/x/AMD-V**
- System -> Acceleration -> **Enable Nested Paging**
- Storage -> Attach a **.vdi** disk (this one we can minimize later)
- Network -> Adapter 1 -> Advanced -> Adapter Type -> **Paravirtualized Network (virtio-net)**
- Network -> Adapter 2 -> Advanced -> Attached to -> **Host-Only Adapter**
- Network -> Adapter 2 -> Advanced -> Adapter Type -> **Paravirtualized Network (virtio-net)**

I would also recommend to disable all the things you are not using, such as
*audio* and *usb*.

### Installation from FreeBSD ISO

Attach the ISO as a CD and boot it. Default installation should work.
Select UTC when asked for timezone and machine hardware clock.
In network configuration step select vtnet0 and configure it with IPv4 DHCP.

### Configuration

Boot into your clean FreeBSD installation. You can now run the
`vagrant-installation.sh` script from this repository. This will install and
setup everything which is needed for Vagrant to run. First, in your FreeBSD
box, login as root and fetch the installation script:

    fetch -o /tmp/vagrant-setup.sh https://raw.github.com/calvinhp/vagrant-freebsd/master/bin/vagrant-setup.sh

Run it:

    sh /tmp/vagrant-setup.sh

### Package for Vagrant

Before packaging, I would recommend trying to reduce the size of the disk a
bit more. In Linux you can do:

    VBoxManage modifyvdi <freebsd-virtual-machine>.vdi compact

You can now package the box by running the following on your local machine:

    vagrant package --base <name-of-your-virtual-machine> --output <name-of-your-box>

## Credits

I forked this repository from [arkadijs freebsd].

## License

The above is released under the BSD license -- who would have thought!
Meaning, do whatever you want, but I would sure appreciate if you contribute
any improvements back to this repository.

[FreeBSD]: http://www.freebsd.org/
[Vagrant]: http://www.vagrantup.com/
[Vagrantfile]: https://github.com/calvinhp/vagrant-freebsd/blob/master/Vagrantfile
[9.2-RELEASE-amd64 special edition]: http://mfsbsd.vx.sk/
[9.2-RELEASE-i386]: http://ftp.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/9.2/FreeBSD-9.2-RELEASE-i386-disc1.iso
[arkadijs freebsd]: https://github.com/arkadijs/vagrant-freebsd
[wunki freebsd]: https://github.com/wunki/vagrant-freebsd
