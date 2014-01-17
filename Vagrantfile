# -*- mode: ruby; -*-

Vagrant.configure("2") do |config|
  config.vm.guest = :freebsd
  config.vm.box = "freebsd-9.2"
  config.vm.box_url = "http://localhost/calvin/freebsd-9.2.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #config.vm.network :forwarded_port, guest:  80, host: 9080, auto_correct: true
  #config.vm.network :forwarded_port, guest: 443, host: 9443, auto_correct: true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "10.0.1.10"

  # Use NFS as a shared folder
  config.vm.synced_folder ".", "/vagrant", :nfs => true, id: "vagrant-root"

  ## For masterless, mount your file roots file root
  config.vm.synced_folder "salt/roots/salt", "/usr/local/etc/salt/states", :nfs => true, id: "salt-root-states"
  config.vm.synced_folder "salt/roots/pillar", "/usr/local/etc/salt/pillar", :nfs => true, id: "salt-root-pillar"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--usb", "off"]
    vb.customize ["modifyvm", :id, "--usbehci", "off"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end

  ## Set your salt configs here
  config.vm.provision :salt do |salt|
    salt.verbose = true

    ## Minion config is set to ``file_client: local`` for masterless
    salt.minion_config = "salt/minion"

    ## Installs our example formula in "salt/roots/salt"
    salt.run_highstate = true
  end

end
