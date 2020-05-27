#!/bin/bash -e

main() {

  # update APT repository
  sudo apt-get update

  # install blazemeter taurus
  sudo apt-get install -y python3 default-jre-headless python3-tk python3-pip python3-dev \
      libxml2-dev libxslt-dev zlib1g-dev net-tools
  sudo python3 -m pip install bzt

}

main
