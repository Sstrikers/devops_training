
package 'install yum-utils' do
	package_name 'yum-utils'
end

yum_repository 'docker-ce-stable' do
	description "Docker CE Stable - $basearch"
	baseurl "https://download.docker.com/linux/centos/7/$basearch/stable"
	gpgkey "https://download.docker.com/linux/centos/gpg"
	action :create
end

package 'install docker-ce' do
	package_name 'docker-ce'
end

directory '/etc/docker' do
	owner 'root'
	group 'root'
	mode '700'
	action :create
end

file '/etc/docker/daemon.json' do
	content '{ "insecure-registries" : ["'+node['dockerdeploy']['registry_url']+'"] }'
	action :create
end

service 'docker' do
	action [:enable, :start]
end
