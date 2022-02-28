---
description: Docker
---

# Docker

**Description:**

Need to analyze containers for security issues. Must Integrate into our CI/CD pipeline to ensure that only images that meet your security and compliance requirements are deployed.

**Tools:**

* Trivy

This does not involve Kubernetes, which of course has gotten a bit complex in general and security is a big contributor to this complexity.

* User Namespaces
* Syscalls: SecComp, Sysdig, Falco&#x20;
* Runtimes: gvisor, Kata, Firecracker
* Image scanning → trivy (see above, main item)
* Image signing: Notary, ContentTrust
* Docker API: Twistlock probably the only one worth it
* Service Mesh: Istio, Envoy
* CIS: CIS benchmark docker, DevSec image framework

