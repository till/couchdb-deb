# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "lucid64"
  config.vm.network :hostonly, "133.0.0.108"

  #config.vm.boot_mode = :gui

  config.vm.provision :shell, :path => "./init.sh"

  # link keys into VM
  config.vm.share_folder("v-root", "/home/vagrant/.gnupg", "#{ENV['HOME']}/.gnupg", :nfs => false)

  # current dir into ~/buildbox
  config.vm.share_folder("v-package", "/home/vagrant/buildbox", ".", :nfs => false)

end
