#! /usr/bin/env bash

## Usage:
## wget https://gist.githubusercontent.com/mimimalizam/485137fe544ffb4d50d6f3d67bbafafc/raw/es-semaphore.sh && bash es-semaphore.sh <es-version>
##

ES_HOST="0.0.0.0"
ES_PORT="9200"
ES_VERSION=${1:-'5.0.0'}
DEB='elasticsearch-'"$ES_VERSION"'.deb'
URL="https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/$ES_VERSION/$DEB"

function get_download_link() {
  # replace dot with dash

  # find the download link
  wget 
}

function stall_for_elasticsearch() {
  echo ">> Waiting for ElasticSearch to become available"

  while true; do
    printf "."

    nc -4 -w 5 $ES_HOST $ES_PORT 2>/dev/null && break
    sleep 1
  done
  
  printf "\n"
}

function setup_java() {
  source /opt/change-java-version.sh
  change-java-version 8
}

function remove_installed_version() {
  sudo service elasticsearch stop
  sudo apt-get purge -y elasticsearch
  sudo rm -rf /var/lib/elasticsearch
}

function install_new_version() {
  if ! [ -e $SEMAPHORE_CACHE_DIR/$DEB ]; then (cd $SEMAPHORE_CACHE_DIR; wget $URL); fi

  echo ">> Installing ElasticSearch $ES_VERSION"
  echo 'Y' | sudo dpkg -i $SEMAPHORE_CACHE_DIR/$DEB

  sudo service elasticsearch start

  echo ">> Installation completed"
}

function run_health_check() {
  echo ">> Running health check..."
  curl http://"$ES_HOST":"$ES_PORT"/_cluster/health?pretty=true
}

setup_java

remove_installed_version

install_new_version

stall_for_elasticsearch

run_health_check






https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.3.0/elasticsearch-2.3.0.deb

sleep 5
curl 'http://localhost:9200/?pretty'


Semaphore (56 min left): ~/tests $ curl 'http://localhost:9200/?pretty'
{
  "name" : "lBMlQOe",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "TrwFrWEVRuqGYBfwFJZL3Q",
  "version" : {
    "number" : "5.4.3",
    "build_hash" : "eed30a8",
    "build_date" : "2017-06-22T00:34:03.743Z",
    "build_snapshot" : false,
    "lucene_version" : "6.5.1"
  },
  "tagline" : "You Know, for Search"
}

{
  "name" : "Rax",
  "cluster_name" : "elasticsearch",
  "version" : {
    "number" : "2.3.0",
    "build_hash" : "8371be8d5fe5df7fb9c0516c474d77b9feddd888",
    "build_timestamp" : "2016-03-29T07:54:48Z",
    "build_snapshot" : false,
    "lucene_version" : "5.5.0"
  },
  "tagline" : "You Know, for Search"
}
