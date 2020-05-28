#!/bin/bash -e

main() {

  # install APT repositories
  sudo apt-get update
  sudo apt-get install -y gnupg
  sudo apt-get install -y apt-transport-https
  sudo apt-get install -y software-properties-common wget ansible
  wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

  # add grafana repository 
  sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

  # install prometheus
  sudo apt-get update
  sudo apt-get install -y prometheus
  sudo apt-get install -y prometheus-node-exporter

  # install grafana
  sudo apt-get install -y grafana

  # launch grafana
  sudo systemctl daemon-reload
  sudo systemctl enable grafana-server
  sudo systemctl start grafana-server

}

main
