---
title: "LNMP手动配置"
date: 2020-12-31T14:40:32+08:00
Description: ""
Tags: []
Categories: []
DisableComments: false
---
`lsb_release -a `查看当前Linux系统版本信息`lsb_release -d`更清楚看到是哪个发行版。如果lsb_release命令找不到，就执行` yum install redhat-lsb -y`

当前系统版本信息： CentOS Linux release 7.9.2009 (Core)

# nginx
`yum install nginx` 如果没有安装包就添加仓库 `yum install epel-release`，如果这是您第一次从 EPEL 仓库中安装软件，yum 可能会提示您导入 EPEL GPG key。遇到这种情况，输入 y，然后 Enter（回车） 即可继续安装。

`systemctl enable nginx`设置开启启动，`find / -name "nginx.conf`，`locate nginx.conf` 两种方式查找nginx.conf配置文件位置。

启动nginx`systemctl start nginx` 出现无法绑定错误nginx: [emerg] still could not bind() ，解决方法killall -9 nginx，关闭占用端口的服务，这里是nginx占用。

# php
添加php Webtatic yum源

```
CentOS6:
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
-------------------------------------------------------------------------
CentOS7:
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
安装php7.0
yum -y install php70w-fpm 
启动php两种方式
systemctl start php-fpm.service
systemctl enable php-fpm.service
查看php版本
php-fpm -v
```

# mariadb
```
yum install mariadb mariadb-server
systemctl start mariadb   #启动mariadb
systemctl enable mariadb  #设置开机自启动
mysql_secure_installation #设置root密码等相关
mysql -uroot -p           #测试登录
----------------------------------------------------
CREATE DATABASE databasename;
GRANT ALL PRIVILEGES ON databasename.* TO "wordpressusername"@"hostname" IDENTIFIED BY "password";
FLUSH PRIVILEGES
示例：  
create database test;
grant all on test.* to 'root'@'%' indentified by 'root'
flush privileges
```

# 其他
赋权限 chmod 777 -R wwwroot

对于PHP7.1     
yum-config-manager --enable remi-php71  
yum -y install php php-opcache  
添加PHP常用扩展：  
yum -y install php-mysql php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel  
对于Nginx:    
yum -y install nginx nginx-mod-http-perl nginx-mod-stream nginx-filesystem nginx-mod-mail nginx-mod-http-image-filter nginx-all-modules nginx-mod-http-geoip  nginx-mod-http-xslt-filter  

nginx.conf文件配置

在server里面添加网站目录 root /home/wwwroot

添加php配置
```
 location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        }
```