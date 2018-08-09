#!/usr/bin/env bash
set -e

php_ver=${1:-'7.2.7'}
php_cache_archive="$SEMAPHORE_CACHE_DIR/php-cache.tar.gz"

if [ -e $php_cache_archive ]; then
  echo "Restoring php installation cache..."
  tar -xf $php_cache_archive -C $SEMAPHORE_CACHE_DIR
  rm -rf ~/.phpbrew/build/php-$php_ver
  cp -r $SEMAPHORE_CACHE_DIR/php-$php_ver ~/.phpbrew/build
  echo "Php installation cache restored."
else
  echo "Cacheed php installation not found, compiling php..."
  echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/ondrej.list
  install-package --update-new argon2 libargon2-0 libargon2-0-dev

  cd ~/.phpbrew/build/php-$php_ver/
  sudo make clean
  ./configure --prefix=/home/runner/.phpbrew/php/php-$php_ver --with-config-file-path=/home/runner/.phpbrew/php/php-$php_ver/etc --with-config-file-scan-dir=/home/runner/.phpbrew/php/php-$php_ver/var/db --with-pear=/home/runner/.phpbrew/php/php-$php_ver/lib/php --disable-all --enable-session --enable-short-tags --with-zlib=/usr --with-libdir=lib/x86_64-linux-gnu --with-openssl=/usr --enable-libxml --enable-simplexml --enable-xml --enable-xmlreader --enable-xmlwriter --with-xsl --with-libxml-dir=/usr --with-sqlite3 --with-pdo-sqlite --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pgsql=../share/postgresql-common/pg_wrapper --with-pdo-pgsql=../share/postgresql-common/pg_wrapper --enable-pdo --enable-bcmath --with-bz2=/usr --enable-calendar --enable-cli --enable-ctype --enable-dom --enable-fileinfo --enable-filter --enable-shmop --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-json --enable-mbregex --enable-mbstring --with-mhash=/usr --with-mcrypt=/usr --enable-pcntl --with-pcre-regex --enable-phar --enable-posix --with-readline=/usr --enable-sockets --enable-tokenizer --with-curl=/usr --enable-zip --with-curl=/usr/local --with-password-argon2
  sudo make
  sudo make install
  echo "Compile complete."
  
  rm -rf $SEMAPHORE_CACHE_DIR/php-$php_ver
  cp -r ~/.phpbrew/build/php-$php_ver $SEMAPHORE_CACHE_DIR/php-$php_ver
fi
