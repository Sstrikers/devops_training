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
    #Create a folder for git if it doesn't exist
        if ! [ -d /home/vagrant/devops_training ]
          then
            mkdir /home/vagrant/devops_training
          else
          echo "Directory /home/vagrant/devops_training already exists"
        fi
    #Clone the repository
        if ! [ -f /home/vagrant/devops_training/README.md ]
          then
            git clone https://github.com/Sstrikers/devops_training.git /home/vagrant/devops_training          
          else
          echo "Repository devops_training already exists"
        fi
    #Switch to new branch task2
        cd /home/vagrant/devops_training/
        git checkout task2
    #Print to console context of the file
        cat /home/vagrant/devops_training/Task2file
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
      SHELL
    end
end


