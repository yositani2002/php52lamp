#
# Cookbook Name:: web_app
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service "iptables" do
  supports :status => true, :restart => true, :reload => true, :stop => true
  action [ :disable , :stop ]
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable , :start ]
end

directory '/var/www/html' do
  owner 'vagrant'
  group 'vagrant'
  mode '0777'
end

directory "/srv/www/php55lamp/web" do
  owner 'vagrant'
  group 'vagrant'
  recursive true
  mode '0755'
  action :create
  not_if { File.exists? "/srv/www/php55lamp/web" }
end

service "httpd"

include_recipe "apache2"
execute "a2dissite default"
web_app "php55lamp" do
  docroot "/srv/www/php55lamp/web"
  template "php55lamp.conf.erb"
  server_name node[:fqdn]
  server_aliases [node[:hostname], "php55lamp"]
end


bash "set-http-umask" do
  exists="grep umask /etc/sysconfig/httpd"
  code <<-EOF
    echo 'umask 002' >> /etc/sysconfig/httpd 
  EOF
  not_if exists
end

bash "create-swap" do
  exists="swapon -s | grep swapfile"
  code <<-EOL
    dd if=/dev/zero of=/swapfile bs=1024 count=512k
    mkswap /swapfile
    swapon /swapfile
  EOL
  not_if exists
end
