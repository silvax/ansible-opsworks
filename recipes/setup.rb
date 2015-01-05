require 'json'

Chef::Application.fatal!("'ansible['environment']' must be defined in custom json for the opsworks stack") if node['ansible'].nil? || node['ansible']['environment'].nil? || node['ansible']['environment'].empty?

extra_vars = {}
extra_vars['opsworks'] = node['opsworks']
extra_vars['ansible']  = node['ansible']

execute "tag instance" do
  command "aws ec2 create-tags --tags Key=environment,Value=#{node['ansible']['environment']} Key=role,Value=#{node['opsworks']['instance']['layers'].first} --resources `curl http://169.254.169.254/latest/meta-data/instance-id/` --region #{node['opsworks']['instance']['region']}"
  action :run
end

execute "configure base" do
  command "ansible-playbook -i /home/ec2-user/base/inv /home/ec2-user/base/configure.yml"
  only_if { ::File.exists?("/home/ec2-user/base/configure.yml")}
  action :run
end

execute "setup" do
  command "ansible-playbook -i /home/ec2-user/ansible/inv /home/ec2-user/ansible/#{node['opsworks']['activity']}.yml --extra-vars '#{extra_vars.to_json}'"
  only_if { ::File.exists?("/home/ec2-user/ansible/#{node['opsworks']['activity']}.yml")}
  action :run
end

if ::File.exists?("/home/ec2-user/ansible/#{node['opsworks']['activity']}.yml")
  Chef::Log.info("Log into #{node['opsworks']['instance']['private_ip']} and view /var/log/ansible.log to see the output of your ansible run")
else
  Chef::Log.info("No updates: /home/ec2-user/ansible/#{node['opsworks']['activity']}.yml not found")
end
