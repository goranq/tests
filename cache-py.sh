#!/usr/bin/env bash

py_ver=${1:-'3.7.0'}
py_dir="py$py_ver"
py_path="$SEMAPHORE_CACHE_DIR/$py_dir"
py_archive="$SEMAPHORE_CACHE_DIR/py$py_ver-cache.tar.gz"

if [ -d $py_path ]; then
  echo "Removing old archive..."
  rm -f $py_archive

  echo "Creating new archive ..."
  tar -czf $py_archive -C $SEMAPHORE_CACHE_DIR $py_dir

  echo "Removing Python $py_ver dir..."
  rm -rf $py_path

  echo "Done."
else
  echo "No Python $py_ver installation cache found. Skipping compressing."
fi
