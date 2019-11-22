---
description: Threat model and security considerations
---

# Threat Model

### **Terra Threat Model**

In the context of Docker containers usage in Terra we consider the following threat scenarios: 

{% hint style="danger" %}
**Threat Scenarios**

* Exploitation of a vulnerability present in an Image
* Exploitation of Container Runtime
* Running an insecure or poisoned image - this is especially relevant in 
{% endhint %}

Auditing docker containerized environment from a security perspective involves identifying security misconfigurations while deploying and running docker containers. Auditing docker containers and its runtime environment requires inspecting the following components.

* Docker images
* Docker containers
* Docker networks
* Docker registries
* Docker volumes
* Docker runtime



