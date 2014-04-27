php52lamp
=========

apache benchでベンチマークをとるために作成しました。

vagrant と provision.shファイルでLAMP構成を自動構築します。
Apache2.2,PHP5.2,MySQL

PHPはソースインストールとなっています。

基本的にCentOS6.5を前提としています。:

    $ vagrant box add centos65 <box url>
  
    
以下のサイトからCentOS6.5向けのイメージを探し、上記の<box url>に入れてください。:

    http://www.vagrantbox.es/

例):

    $ vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box

vagrantファイルでipを固定で割り振っています。
都合が悪い場合は以下の内容を適宜書き換えてください。:

    $ vim Vagrantfile
    config.vm.network "private_network", ip: "192.168.33.13"

以下のように vagrant up を実行する事で、provision.shが実行されます。:

    $ vagrant up

SSHのホスト名設定

    $ vagrant ssh-config --host php52lamp >> ~/.ssh/config

provision.shはPHP5.2.17をソースインストールします。

apache benchの実行
------------------

document rootは/vagrant/abtest/webとなっております。

    $ ssh php52lamp
    (php52lamp) $ ab -n 1000 -c 100 http://localhost/soap.php
    
