
Vagrant.configure("2") do |config|
	config.vm.box = "bertvv/centos72"
	config.vm.define "apache" do |apache|
		#Set VM and network
		apache.vm.hostname = "apache"
		apache.vm.network "private_network", ip: "192.168.56.10"
		apache.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
		apache.vm.provision "shell", inline: <<-SHELL
		#Install httpd
		yum install httpd -y
		systemctl enable httpd
		systemctl start httpd
		#Allow http port
		firewall-cmd --zone=public --add-port=80/tcp --permanent
		firewall-cmd --reload
		#Copy mod_jk module
		cp /vagrant/mod_jk.so /etc/httpd/modules/
		#Edit load balance config
		if ! [ -f /etc/httpd/conf/workers.properties ]
			then
				echo "worker.list=lb" >> /etc/httpd/conf/workers.properties
				echo "worker.lb.type=lb" >> /etc/httpd/conf/workers.properties
				echo "worker.lb.balance_workers=tomcat1, tomcat2" >> /etc/httpd/conf/workers.properties
				echo "worker.list=lb" >> /etc/httpd/conf/workers.properties
				echo "worker.tomcat1.host=192.168.56.11" >> /etc/httpd/conf/workers.properties
				echo "worker.tomcat1.port=8009" >> /etc/httpd/conf/workers.properties
				echo "worker.tomcat1.type=ajp13" >> /etc/httpd/conf/workers.properties
				echo "worker.tomcat2.host=192.168.56.12" >> /etc/httpd/conf/workers.properties
				echo "worker.tomcat2.port=8009" >> /etc/httpd/conf/workers.properties
				echo "worker.tomcat2.type=ajp13" >> /etc/httpd/conf/workers.properties
			else 
				echo "File /etc/httpd/conf/workers.properties already exists"
		fi
		if ! [ -f /etc/httpd/conf.d/test_lb.conf ]
			then
				echo "LoadModule jk_module modules/mod_jk.so" >> /etc/httpd/conf.d/test_lb.conf
				echo "JkWorkersFile conf/workers.properties" >> /etc/httpd/conf.d/test_lb.conf
				echo "JkShmFile /tmp/shm" >> /etc/httpd/conf.d/test_lb.conf
				echo "JkLogFile logs/mod_jk.log" >> /etc/httpd/conf.d/test_lb.conf
				echo "JkLogLevel info" >> /etc/httpd/conf.d/test_lb.conf
				echo "JkMount /test* lb" >> /etc/httpd/conf.d/test_lb.conf
				systemctl restart httpd
			else
				echo "File /etc/httpd/conf.d/test_lb.conf already exists"
		fi
		SHELL
	end

	config.vm.define "tomcat1" do |tomcat1|
		#Set VM tomcat1 & network & memory
		tomcat1.vm.hostname = "tomcat1"
		tomcat1.vm.provider "virtualbox" do |v|
			v.memory = 1024
		end
		tomcat1.vm.network "private_network", ip: "192.168.56.11"
		tomcat1.vm.provision "shell", inline: <<-SHELL
		#Install tomcat
		yum install tomcat tomcat-webapps tomcat-admin-webapps -y
		systemctl enable tomcat 
		systemctl start tomcat 
		#Allow ajp13 protocol port
		firewall-cmd --zone=public --add-port=8009/tcp --permanent
		firewall-cmd --reload
		#Add application to the tomcat1 server if it not exists
		mkdir /usr/share/tomcat/webapps/test
		if ! [ -f /usr/share/tomcat/webapps/test/index.html ]
			then
				echo "tomcat1" >> /usr/share/tomcat/webapps/test/index.html
			else 
				echo "File /usr/share/tomcat/webapps/test/index.html already exists"
		fi
		SHELL
	end

	config.vm.define "tomcat2" do |tomcat2|
		#Set VM tomcat2 & network & memory
		tomcat2.vm.hostname = "tomcat2"
		tomcat2.vm.provider "virtualbox" do |v|
			v.memory = 1024
		end
		tomcat2.vm.network "private_network", ip: "192.168.56.12"
		tomcat2.vm.provision "shell", inline: <<-SHELL
		#Install tomcat
		yum install tomcat tomcat-webapps tomcat-admin-webapps -y
		systemctl enable tomcat 
		systemctl start tomcat 
		#Allow ajp13 protocol port
		firewall-cmd --zone=public --add-port=8009/tcp --permanent
		firewall-cmd --reload
		#Add application to the tomcat2 server if it not exists
		mkdir /usr/share/tomcat/webapps/test
		if ! [ -f /usr/share/tomcat/webapps/test/index.html ]
			then
				echo "tomcat2" >> /usr/share/tomcat/webapps/test/index.html
			else 
				echo "File /usr/share/tomcat/webapps/test/index.html already exists"
		fi
		SHELL
	end
end
