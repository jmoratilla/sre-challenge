
My goal is to create a three node cluster with following features:

- 12factor app architecture
- Proxy
- SSL
- Authentication
- Monitorization
- Benchmarking

## Plan

1. Build image
    - AWS AMI
    - Docker Image
2. Push image
    - AWS
    - Docker Hub
2. Provision image
    - Terraform
3. Configure service
4. Monitor
5. Test




## Options

- Static Cluster (not good in cloud)
  - provision images
  - get IP addresses
  - launch etcd provisioned with the cluster IPs

- Discovery by URL
  - provision image
  - launch etcd with the discovery token

- Discovery by DNS
  - provision image
  - launch etcd with the discovery domain

## Deploy the cluster


