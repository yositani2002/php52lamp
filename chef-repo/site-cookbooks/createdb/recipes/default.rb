#
# Cookbook Name:: createdb
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "create .pgpass" do
  exists = "ls ~/.pgpass | grep -c .pgpass"
  command "echo *:*:*:postgres:#{node['postgresql']['password']['postgres']} > ~/.pgpass && chmod 600 ~/.pgpass"
  not_if exists
end


execute "create-symfony-database" do
    exists = <<-EOH
    psql -U postgres \
    -h localhost \
    -c "select * from pg_database WHERE datname='#{node['postgresql']['dbname']}'"\
    | grep -c #{node['postgresql']['dbname']}
    EOH

    command "createdb -U postgres -O postgres -E utf8 -h localhost -T template0 #{node['postgresql']['dbname']}"

    not_if exists
end

execute "create-session-database" do
    exists = <<-EOH
    psql -U postgres \
    -h localhost \
    -c "select * from pg_database WHERE datname='session'"\
    | grep -c session 
    EOH

    command "createdb -U postgres -O postgres -E utf8 -h localhost -T template0 session"

    not_if exists
end

