#!/bin/sh
yum -y -q install git httpd mariadb-server epel-release
pushd /etc/yum.repos.d
curl -Ss -O http://rpms.famillecollet.com/enterprise/remi.repo
popd
yum -y -q --enablerepo=remi,remi-php56 install php php-common php-mbstring php-intl php-pdo php-devel php-xml phpmyadmin
sed -i -e 's/Require local/Require all granted/g' /etc/httpd/conf.d/phpMyAdmin.conf

systemctl start httpd
systemctl start mariadb
systemctl stop firewalld

mysqladmin password secret -u root

systemctl enable httpd
systemctl enable mariadb
systemctl disable firewalld

curl -Ss https://getcomposer.org/installer > composer-setup.php
php composer-setup.php
mv composer.phar /usr/local/bin/composer

# curl -sL https://rpm.nodesource.com/setup_7.x | bash -
# yum install -y nodejs libnotify
# npm install -g gulp
# npm i -D gulp