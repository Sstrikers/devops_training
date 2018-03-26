require 'socket'
require 'timeout'

def check_port?(ip, port, time)
	Timeout::timeout(time) do
		begin
			TCPSocket.new(ip, port).close
			true
		rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
			false
		end
	end
	rescue Timeout::Error
		false
end


if check_port?("192.168.56.10", 8082, 4)
	runningContainerId = `docker ps -f publish=8080 | grep 8082 | awk '{print $1}'`.rstrip
	puts "Container on port 8082 has ID "+runningContainerId
	docker_container "test-#{node['dockerdeploy']['imageVersion']}-p8083" do
		repo "#{node['dockerdeploy']['registry_url']}:#{node['dockerdeploy']['registry_port']}/task7"
		tag "#{node['dockerdeploy']['imageVersion']}"
		restart_policy "always"
		port "8083:8080"
		action :run
	end

	docker_container "#{runningContainerId}" do
		action [:stop, :delete]
	end

else
	docker_container "test-#{node['dockerdeploy']['imageVersion']}-p8082" do
		repo "#{node['dockerdeploy']['registry_url']}:#{node['dockerdeploy']['registry_port']}/task7"
		tag "#{node['dockerdeploy']['imageVersion']}"
		restart_policy "always"
		port "8082:8080"
		action :run
	end
	runningContainerId = `docker ps -f publish=8080 | grep 8083 | awk '{print $1}'`.rstrip
	puts "Container on port 8082 has ID "+runningContainerId
	unless runningContainerId.empty?
		docker_container "#{runningContainerId}" do
			action [:stop, :delete]
		end
	end
end



