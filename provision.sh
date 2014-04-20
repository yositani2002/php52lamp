#!/bin/bash
yum install -y wget vim
yum install -y httpd
yum install -y gcc make httpd-devel libxml2-devel openssl-devel curl-devel gd gd-devel gmp-devel libtool-ltdl libtool-ltdl-devel mysql-devel libxslt-devel

#libmcrypt
wget http://elders.princeton.edu/data/puias/unsupported/6/x86_64/libmcrypt-2.5.8-9.puias6.x86_64.rpm
wget http://elders.princeton.edu/data/puias/unsupported/6/x86_64/libmcrypt-devel-2.5.8-9.puias6.x86_64.rpm
rpm -ivh libmcrypt-2.5.8-9.puias6.x86_64.rpm
rpm -ivh libmcrypt-devel-2.5.8-9.puias6.x86_64.rpm

#PHP5.2.17
wget http://museum.php.net/php5/php-5.2.17.tar.gz
tar zxvf php-5.2.17.tar.gz
cd php-5.2.17
./configure --with-apxs2 --enable-calendar --with-curl --with-gd \
--with-gettext --with-gmp --with-ldap --enable-mbstring --with-mcrypt \
--with-mysql --with-mysqli --with-openssl --with-pdo-mysql \
--enable-shmop --enable-soap --enable-sockets --enable-sysvmsg \
--enable-wddx --enable-xml --with-xsl --with-zlib \
--with-config-file-path=/etc --with-zlib-dir --enable-mbregex \
--with-pcre-regex --with-libdir=lib64 --with-pear --enable-bcmath \
--enable-zip --with-mysqli --enable-sockets
make
make install
## Set php.ini
cp php.ini-recommended /etc/php.ini
## APC
printf "\n" | /usr/local/bin/pecl install apc
sed -i 's#extension_dir = "./"#extension_dir = "/usr/local/lib/php/extensions/no-debug-non-zts-20060613/"#' /etc/php.ini
echo "extension=apc.so" >> /etc/php.ini
cd ..
yum install -y mysql mysql-server
/etc/init.d/mysqld start

#iptables
/sbin/iptables -F
/etc/init.d/iptables save

#httpd.conf
echo "AddType application/x-httpd-php .php" >> /etc/httpd/conf/httpd.conf
echo "<IfModule dir_module>" >> /etc/httpd/conf/httpd.conf
echo -e "\tDirectoryIndex index.php index.php4 index.php3 index.cgi index.pl index.html index.htm index.shtml index.phtml" >> /etc/httpd/conf/httpd.conf
echo "</IfModule>" >> /etc/httpd/conf/httpd.conf

#vhost.conf
touch /etc/httpd/conf.d/vhost.conf
echo "NameVirtualHost *:80" >> /etc/httpd/conf.d/vhost.conf

echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/vhost.conf
echo -e "\tServerName hogeadmin.localhost.hoge" >> /etc/httpd/conf.d/vhost.conf
echo -e "\tErrorLog logs/abtest-error.log" >> /etc/httpd/conf.d/vhost.conf
echo -e "\tCustomLog logs/abtest-access.log common" >> /etc/httpd/conf.d/vhost.conf
echo -e "\tDocumentRoot /vagrant/abtest/web" >> /etc/httpd/conf.d/vhost.conf
echo -e "\t<Directory /vagrant/abtest/web>" >> /etc/httpd/conf.d/vhost.conf
echo -e "\t\tOptions Indexes FollowSymLinks Includes ExecCGI" >> /etc/httpd/conf.d/vhost.conf
echo -e "\t\tAllowOverride All" >> /etc/httpd/conf.d/vhost.conf
echo -e "\t\tOrder allow,deny" >> /etc/httpd/conf.d/vhost.conf
echo -e "\t\tAllow from all" >> /etc/httpd/conf.d/vhost.conf
echo -e "\t</Directory>" >> /etc/httpd/conf.d/vhost.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/vhost.conf


#mysql
mysql -u root mysql -e "GRANT ALL PRIVILEGES ON *.* TO root@'%';"
echo "[client]" >> /etc/my.cnf
echo "default-character-set = utf8" >> /etc/my.cnf
echo "[mysqld]" >> /etc/my.cnf
echo "character-set-server = utf8" >> /etc/my.cnf

#etc/hosts
echo "127.0.0.1   hogeadmin.localhost.hoge hogestore.localhost.hoge" >> /etc/hosts

#apache etc.
cp /usr/share/zoneinfo/Japan /etc/localtime
echo "TZ=Japan" >> /etc/sysconfig/httpd
echo "export TZ" >> /etc/sysconfig/httpd

#service
chkconfig --add mysqld
chkconfig --level 345 mysqld on
chkconfig --level 345 httpd on

#daemon restart
/etc/init.d/httpd restart
/etc/init.d/mysqld restart

#importing test dump
mysql -u root -e 'create database `stg-hoge` DEFAULT CHARACTER SET utf8;'
mysql -u root stg-hoge < /vagrant/stg-hoge.sql
