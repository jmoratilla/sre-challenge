FROM debian:stretch-slim

VOLUME /etcd-data
VOLUME /config

# define env vars
ENV ETCD_VER=v3.4.8

# choose either URL
ENV GOOGLE_URL=https://storage.googleapis.com/etcd
ENV GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ENV DOWNLOAD_URL=${GOOGLE_URL}

# update and install curl
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl

# install etcd database
RUN mkdir -p /opt/etcd \
    && curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz \
    &&  tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /opt/etcd --strip-components=1
    
# clear
RUN rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

ENTRYPOINT [ "/opt/etcd/etcd" ]

