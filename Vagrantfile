# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box     = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.network :hostonly, "33.33.33.254"

  #config.vm.boot_mode = :gui

  config.vm.provision :shell, :path => "./init.sh"

  # link keys into VM
  config.vm.share_folder("v-root", "/home/vagrant/.gnupg", "#{ENV['HOME']}/.gnupg", :nfs => false)

  # current dir into ~/buildbox and allow symlinks
  config.vm.share_folder("v-buildbox", "/home/vagrant/buildbox", ".", :nfs => false)
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-buildbox", "1"]

end
