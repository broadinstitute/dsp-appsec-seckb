---
description: Docker attack patterns
---

# Attacking Dockers

## Background

One of the biggest changes in the emergence of Docker is a revolution in the application delivery model. Docker can encapsulate the production environment, and can be quickly deployed based on mirroring, dynamic migration and elastic scaling. In the past, if you needed to release an application you must first build an environment in the development environment, install, configure, and then do an installation and configuration in the test environment, then build in the production environment. Amongst numerous benefits that Docker has brought to application delivery, one of the major benefits in terms of operation and maintenance is that it's readable. After using Docker all the configuration done in the production environment is written in a file, such as `Dockerfile, YAML file, etc`. Docker has made a big and disruptive change to the traditional application delivery. 

_**So what are the characteristics of its traditional security solutions?**_ 

* First of all, Docker itself provides a new attack point.
* Secondly, because Docker shares the kernel with the host, it can enter other containers on the host by breaking the kernel, so this also provides a new attack opportunity. 
* Third, Docker itself is a piece of software and vulnerabilities in it present a new challenge. 

_**Docker use**_

The container needs to dispatch the system. If you only used a single Docker, you may enjoy its environment encapsulation and ease of migration. However, after using the container on a large scale, you should care about how its scheduling is done, the then scheduling system is also a new one. This is a point of attack. This new deployment will also have some new impact on traditional security work. 

_**Operation vs Maintenance vs Configuration**_

Finally, containers are not the same in terms of operation and maintenance and configuration, and there are some new security issues. So after the advent of Docker, many new security solutions were challenged. For traditional security, the container is equivalent to a virtual machine. It is an operating environment, so it is more of a security of the traditional base layer to increase the security from the outer layer to the inner layer. Here is no way to talk about how traditional security is done, whether you use containers or virtual machines, the traditional solution is to do. This article mainly talks about how Docker itself is safe.

## Attacker's Mindset

As an Attacker one may think attacking the containers to gain access to the host system, data and assets by:

* Attacking container capabilities
* Attacking insecure volume mounts in containers
* Attacking runtime misconfigurations
* Exploiting docker secrets misconfiguration

