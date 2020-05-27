#!/bin/bash -e

main() {
  # create user etcd
  sudo groupadd --system etcd
  sudo useradd -s /sbin/nologin --system -g etcd etcd

  # define env vars
  ETCD_VER=v3.4.8

  # choose either URL
  GOOGLE_URL=https://storage.googleapis.com/etcd
  GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
  DOWNLOAD_URL=${GOOGLE_URL}

  # update and install curl
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install -y curl

  # install etcd database
  sudo mkdir -p /opt/etcd /data
  curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
  sudo tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /opt/etcd --strip-components=1
  sudo chown -R etcd:etcd /opt/etcd /data

  # install systemd service
  cat <<EOF | sudo tee -a /etc/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/etcd-io/etcd
After=network.target

[Service]
User=etcd
Type=notify
Environment=ETCD_DATA_DIR=/data
Environment=ETCD_NAME=%m
Environment=ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
Environment=ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379
ExecStart=/opt/etcd/etcd
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
EOF

  # reload systemd
  sudo systemctl daemon-reload
  sudo systemctl enable etcd
  sudo systemctl start etcd

  # clear
  rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
}

main
