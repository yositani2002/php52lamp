#
# Cookbook Name:: web_app
# Recipe:: php
#
#

%w{php52 php52-common php52-cli  php52-devel
php52-pgsql php52-pdo php52-mysql
php52-gd
gd gd-devel
php52-mbstring
}.each do |php_module|
  package php_module do
      action :install
    end
end

bash "set timezone" do
  user "root"
  code <<-EOL
    cp /etc/php.ini /etc/php.ini.bak
    sed -i 's#;date.timezone =#date.timezone = Asia/Tokyo#' /etc/php.ini 
  EOL
end


bash "set memory_limit" do
  user "root"
  exists="grep '^memory_limit /etc/php.ini'"
  code <<-EOL
    sed -i 's/; memory_limit =.*/memory_limit = 1024M/' /etc/php.ini
  EOL
  not_if exists
end



#bash "apc install" do
#  user "root"
#  code <<-EOL
#    pecl install apc
#  EOL
#end
