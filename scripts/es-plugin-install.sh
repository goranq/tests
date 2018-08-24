#!/bin/bash

set -e

ES_HOST="0.0.0.0"
ES_PORT="9200"
PLUGIN_NAME=$1

function stall_for_elasticsearch() {
  echo ">> Waiting for ElasticSearch to become available"

  while true; do
    printf "."

    nc -4 -w 5 $ES_HOST $ES_PORT 2>/dev/null && break
    sleep 1
  done
  
  printf "\n"
}

function run_health_check() {
  echo ">> Running health check..."
  curl http://"$ES_HOST":"$ES_PORT"/_cluster/health?pretty=true
}

function install_elasticsearch_plugin() {
  echo ">> Installing plugin $PLUGIN_NAME..."
  sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install --batch $PLUGIN_NAME

  curl -L https://gist.githubusercontent.com/ervinb/bff380f0b333f76dca14eae735cb4649/raw/mysql-57-ppa.sh | bash
}

function restart_elasticsearch_service() {
  echo ">> Restarting ElasticSearch service..."
  sudo service elasticsearch restart
}

install_elasticsearch_plugin $PLUGIN_NAME

restart_elasticsearch_service

stall_for_elasticsearch

run_health_check