Vagrant.configure("2") do |config|
  config.vm.box = "{{.BoxName}}"
  
  # Ensure the VM uses a normal start (GUI)
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  end
end