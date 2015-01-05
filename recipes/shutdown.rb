require 'json'

extra_vars = {}
extra_vars['opsworks'] = node['opsworks']
extra_vars['ansible']  = node['ansible']

execute "shutdown" do
  command "ansible-playbook -i /home/ec2-user/ansible/inv /home/ec2-user/ansible/#{node['opsworks']['activity']}.yml --extra-vars '#{extra_vars.to_json}'"
  only_if { ::File.exists?("/home/ec2-user/ansible/#{node['opsworks']['activity']}.yml")}
  action :run
end

if ::File.exists?("/home/ec2-user/ansible/#{node['opsworks']['activity']}.yml")
  Chef::Log.info("Log into #{node['opsworks']['instance']['private_ip']} and view /var/log/ansible.log to see the output of your ansible run")
else
  Chef::Log.info("No updates: /home/ec2-user/ansible/#{node['opsworks']['activity']}.yml not found")
end
