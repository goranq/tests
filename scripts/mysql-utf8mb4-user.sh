#!/bin/bash

set -e

# create needed placeholders in my.cnf file in order for "sed" command to work
echo "[client]" | sudo tee -a /etc/mysql/my.cnf
echo "[mysqld_safe]" | sudo tee -a /etc/mysql/my.cnf
echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf

# Adapted from https://gist.githubusercontent.com/mimimalizam/c5252460906ffa9e9254f9d4e76eb395/raw/utf8mb4-mysql.sh
sudo sed -i "/\[client\]/adefault_character_set='utf8mb4'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld_safe\]/acollation_server='utf8mb4_unicode_ci'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld_safe\]/acharacter_set_server='utf8mb4'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/acollation_server='utf8mb4_unicode_ci'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/acharacter_set_server='utf8mb4'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainit_connect='SET collation_connection=\"utf8_unicode_ci\"'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainit_connect='SET NAMES utf8mb4'" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainnodb_file_format=Barracuda" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainnodb_file_format_max=Barracuda" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainnodb_strict_mode=1" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainnodb_large_prefix=1" /etc/mysql/my.cnf
sudo sed -i "/\[mysqld\]/ainnodb_file_per_table=1" /etc/mysql/my.cnf
sudo service mysql restart
mysql -u $DATABASE_MYSQL_USERNAME -p$DATABASE_MYSQL_PASSWORD -e "SET GLOBAL innodb_file_per_table=1, innodb_file_format=Barracuda, innodb_large_prefix=1;"
mysql -u $DATABASE_MYSQL_USERNAME -p$DATABASE_MYSQL_PASSWORD -e "SHOW VARIABLES WHERE Variable_name LIKE 'character\_set\_%' OR Variable_name LIKE 'collation%';"
mysql -u $DATABASE_MYSQL_USERNAME -p$DATABASE_MYSQL_PASSWORD -e "SELECT @@innodb_file_per_table, @@innodb_file_format;"