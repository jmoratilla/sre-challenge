## Description

This repo contains all the work and docs for a code test.

## Status Badges

TO BE DEFINED

## The way to use and run it

First, download the repository using git:

```shell
$ git clone https://github.com/jmoratilla/sre-challenge.git
```

## About documentation

The documentation is under the doc/ subdirectory and in form of ADRs (Architecture Decision Records), as recomended by [Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).]

## About the code test

The goals for this challenge are to create a cloud architecture capable to support
 an etcd cluster installation.  Check the ADRs to know more about the code and
 the solution.

## Plan stages and status

1. Build images
    - AWS AMI: done
    - Docker Image: done
2. Push images
    - AWS: done
    - Docker Hub: done
2. Provision images
    - Terraform: done
3. Configure services
    - Ansible: done
4. Monitor: 
    - Prometheus: done
    - Grafana: done
5. Test:
    - Blazemeter Taurus: half-done
6. Docker:
    - 1 instance: done
    - cluster: not yet
7. CI/CD:
    - CircleCI[AWS AMIs]: not yet

## Tools used

* [ASDF-VM](https://asdf-vm.com): to install all the packages (like in rbenv)
* [ADR tools](https://github.com/npryce/adr-tools/blob/master/INSTALL.md): to help with the documentation of the decisions assumed in the project.
* [Packer](https://www.packer.io): to build the images
* [Terraform](https://www.terraform.io): to provision the infrastructure and the instances
* [Ansible](https://www.ansible.com): to configure the services after creation
* [ConventionalCommits Guidelines](https://www.conventionalcommits.org/en/v1.0.0/): to ease the CHANGELOG and versioning of the code.

## License

Licensed under the MIT License. See [LICENSE](/license) file.