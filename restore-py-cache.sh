#!/usr/bin/env bash

set -e

py_ver=${1:-'3.7.0'}
py_cache_archive="$SEMAPHORE_CACHE_DIR/py$py_ver-cache.tar.gz"

# Install pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
echo 'export PATH="/home/runner/.pyenv/bin:$PATH"' | tee -a ~/.bash_profile
echo 'eval "$(pyenv init -)"' | tee -a ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' | tee -a ~/.bash_profile
source ~/.bash_profile

# Restore the Python version from cache, if exists
if [ -e $py_cache_archive ]; then
  echo "Restoring Python $py_ver installation cache..."
  tar -xf $py_cache_archive -C $SEMAPHORE_CACHE_DIR
  rm -rf ~/.pyenv/versions/$py_ver
  cp -r $SEMAPHORE_CACHE_DIR/py$py_ver ~/.pyenv/versions
  echo "Python $py_ver installation cache restored."
else
  echo "Cacheed Python $py_ver installation not found, downloading..."
  # install the prerequisites
  sudo apt-get update
  sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdm-dev libc6-dev libbz2-dev zlib1g-dev openssl libffi-dev python3-dev python3-setuptools wget

  pyenv install $py_ver
  
  rm -rf $SEMAPHORE_CACHE_DIR/py$py_ver
  cp -r ~/.pyenv/versions/py$py_ver $SEMAPHORE_CACHE_DIR/py$php_ver
fi

pyenv global $py_ver
