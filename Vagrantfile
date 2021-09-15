provision_ubuntu = <<EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y devscripts equivs

chmod a+w /     # necessary for dpkg-genchanges to write to ..

cd /vagrant
mk-build-deps --install --tool='apt-get --no-install-recommends -y'
EOF

provision_centos = <<EOF
sudo yum install -y epel-release
sudo yum install -y rpmdevtools yum-utils
rpmdev-setuptree

cd /vagrant
sudo yum-builddep -y *.spec
EOF

Vagrant.configure(2) do |config|
  config.vm.define 'ubuntu' do |ubuntu|
    ubuntu.vm.box = 'ubuntu/trusty64'
    ubuntu.vm.provision 'shell', inline: provision_ubuntu
  end

  config.vm.define 'centos' do |centos|
    centos.vm.box = 'centos/7'
    centos.vm.provision 'shell', privileged: false, inline: provision_centos
  end
end
