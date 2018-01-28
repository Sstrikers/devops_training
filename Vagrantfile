#Task2 - vagrant config file

Vagrant.configure("2") do |config|
  config.vm.box = "bertvv/centos72"

    config.vm.define "server1" do |server1|
      server1.vm.hostname = "server1"
      server1.vm.network "private_network", ip: "192.168.56.10"
      server1.vm.provision "shell", inline: <<-SHELL
    #Add server2 to hosts
        sed -i "/server2/d" /etc/hosts
        echo "" >> /etc/hosts
        grep 'server2' /etc/hosts || echo '192.168.56.11 server2' >> /etc/hosts
        echo "" >> /etc/hosts
    #Install git
        yum install git -y
    #Allow public key login
        sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
      SHELL
      server1.vm.provision "shell", privileged:false, inline: <<-SHELL
          #Clone the repository
        if ! [ -f $HOME/devops_training/README.md ]
          then
            git clone -b task2 https://github.com/Sstrikers/devops_training.git
          else
            cat devops_training/Task2file
        fi
        if ! [ -f $HOME/.ssh/id_rsa.pub ]
          then
          ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -q -N ""
          mkdir /vagrant/server1/
          cp -f $HOME/.ssh/id_rsa.pub /vagrant/server1/id_rsa.pub
        fi
        if [ -f /vagrant/server2/id_rsa.pub ] 
          then
            cat /vagrant/server2/id_rsa.pub >> $HOME/.ssh/authorized_keys
            rm /vagrant/server2/id_rsa.pub
        fi
        SHELL
    end

    config.vm.define "server2" do |server2|
      server2.vm.hostname = "server2"
      server2.vm.network "private_network", ip: "192.168.56.11"
      server2.vm.provision "shell", inline: <<-SHELL
    #Add server1 to hosts
        sed -i "/server1/d" /etc/hosts
        echo "" >> /etc/hosts
        grep 'server1' /etc/hosts || echo '192.168.56.10 server1' >> /etc/hosts
        echo "" >> /etc/hosts   
    #Allow public key login
        sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
      SHELL
      server2.vm.provision "shell", privileged:false, inline: <<-SHELL
        if ! [ -f $HOME/.ssh/id_rsa.pub ]
          then
          ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -q -N ""
          mkdir /vagrant/server2/
          cp -f $HOME/.ssh/id_rsa.pub /vagrant/server2/id_rsa.pub 
        fi
        if [ -f /vagrant/server1/id_rsa.pub ] 
          then
          cat  /vagrant/server1/id_rsa.pub >> $HOME/.ssh/authorized_keys
          rm /vagrant/server1/id_rsa.pub
        fi
      SHELL
    end

end


