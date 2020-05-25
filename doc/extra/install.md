To install etcd from a release, perform the following steps:


    # define env vars
    ETCD_VER=v3.4.8

    # choose either URL
    GOOGLE_URL=https://storage.googleapis.com/etcd
    GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
    DOWNLOAD_URL=${GOOGLE_URL}

    # update and install curl
    apt-get update && apt-get upgrade -y && apt-get install -y curl net-tools

    # install etcd database
    mkdir -p /opt/etcd \
        && curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
        &&  tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /opt/etcd --strip-components=1

    # create the etcd data dir
    mkdir -p /etcd-data

    # add the config file
    cp etc/etcd.conf.yml /opt/etcd/

    # clear
    rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

    # go to directory
    cd /opt/etcd

    # execute static
    ./etcd -name etcd1 -data-dir /etcd-data -listen-client-urls http://0.0.0.0:2379 -advertise-client-urls http://0.0.0.0:2379 -listen-peer-urls http://10.0.1.10:2380 -initial-advertise-peer-urls http://0.0.0.0:2380 -initial-cluster-token etcd-cluster-1 -initial-cluster etcd1=http://10.0.1.10:2380,etcd2=http://10.0.1.11:2380,etcd3=http://10.0.1.12:2380 -initial-cluster-state new

    # execute discovery url
    DISCOVERY_TOKEN=`curl -s https://discovery.etcd.io/new?size=3`
    ./etcd -name etcd1 -data-dir /etcd-data \
     -listen-client-urls http://0.0.0.0:2379 \
     -advertise-client-urls http://0.0.0.0:2379 \
     -listen-peer-urls http://10.0.1.10:2380 \
     -initial-advertise-peer-urls http://0.0.0.0:2380  \
     -discovery $DISCOVERY_TOKEN

    # execute  discovery dns-srv
    ./etcd -name etcd1 -data-dir /etcd-data \
     -listen-client-urls http://0.0.0.0:2379 \
     -advertise-client-urls http://0.0.0.0:2379 \
     -listen-peer-urls http://10.0.1.10:2380 \
     -initial-advertise-peer-urls http://0.0.0.0:2380  \
     -discovery-srv example.com

     
