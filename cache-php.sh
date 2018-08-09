#!/usr/bin/env bash

php_dir="php-$php_ver"
php_path="$SEMAPHORE_CACHE_DIR/$php_dir"
php_archive="$SEMAPHORE_CACHE_DIR/php-cache.tar.gz"

if [ -d $php_path ]; then
  echo "Removing old archive..."
  rm -f $php_archive

  echo "Creating new archive ..."
  tar -czf $php_archive -C $SEMAPHORE_CACHE_DIR $php_dir

  echo "Removing uncompressed assets..."
  rm -rf $php_path

  echo "Done."
else
  echo "No php installation cache found. Skipping compressing."
fi
