#!/bin/bash

set -e

# create needed placeholders in my.cnf file in order for "sed" command to work
echo "[client]" | sudo tee -a /etc/mysql/my.cnf
echo "[mysqld_safe]" | sudo tee -a /etc/mysql/my.cnf
echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf

sudo sed -i '/\[client\]/adefault-character-set = utf8mb4' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld_safe\]/acollation-server = utf8mb4_unicode_ci' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld_safe\]/acharacter-set-server = utf8mb4' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/acollation-server = utf8mb4_unicode_ci' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/acharacter-set-server = utf8mb4' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/ainit_connect = SET collation_connection = utf8_unicode_ci' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/ainit_connect = SET NAMES utf8mb4' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/ainnodb_file_format_max = Barracuda' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/ainnodb_strict_mode = 1' /etc/mysql/my.cnf
sudo service mysql restart
mysql -u $DATABASE_MYSQL_USERNAME -p$DATABASE_MYSQL_PASSWORD -e "SHOW VARIABLES WHERE Variable_name LIKE 'character\_set\_%' OR Variable_name LIKE 'collation%';" 