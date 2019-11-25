# SAST

{% tabs %}
{% tab title="Code Repository Management" %}

### Code Repository Management

**Description:**

Monitor Github for secrets checking and other anomalous behavior. 

**Tools:**
Git Secrets:[https://github.com/awslabs/git-secrets](https://github.com/awslabs/git-secrets)
Protected Branches:[https://help.github.com/articles/about-protected-branches/](https://help.github.com/articles/about-protected-branches/)
Pullapprove:[https://www.pullapprove.com/](https://www.pullapprove.com/)
Git-secrets client side protection
TruffleHog/Gitrob as a server-side protection 

**How Can We Do Better?**

Is it widely used? How can we detect that it's being used? 

Zybjana Bedo has setup jenkins jobs

Discussion with GitGuardian
Split jenkins jobs into smaller ones Zybjana Bedo

{% endtab %}
{% tab title="Static Code Analysis" %}

### Static Code Analysis

**Description:**

Static Code Analysis is an activity that is performed continuously and aims to identify issues at a code level. 

**Tools:**
Codacy:[https://app.codacy.com/organization/BroadInstitute](https://app.codacy.com/organization/BroadInstitute)

**How Can We Do Better?**

{% endtab %}
{% tab title="Third Party Libraries" %}

### Third Party Libraries

**Description:**

Third-party libraries have several interesting risks. Obviously, vulnerabilities can be introduced into libraries and we need to ensure that our developers are aware when such things happen. 

**Tools:**
SourceClear:[https://broadinstitute-dsp.sourceclear.io/login](https://broadinstitute-dsp.sourceclear.io/login)
Dependabot: Enabled via Github
Snyk

**How Can We Do Better?**

More automated triage; currently a robust process	

{% endtab %}
{% tab title="Docker" %}

### Docker

**Description:**

Need to analyze containers for security issues. Must Integrate into our CI/CD pipeline to ensure that only images that meet your security and compliance requirements are deployed.

**Tools:**
Trivy:[https://github.com/knqyf263/trivy](https://github.com/knqyf263/trivy) (For docker image scanning via ci/cd. In progress by Albano Drazhi.)

Docker Other, FYI David Bernick Zybjana Bedo. Add if I missed something about the following areas. This does not involve Kubernetes stuff which of course has gotten a bit complex in general and security is a big contributor to this complexity. 
	* User Namespaces
	* Syscalls: SecComp, Sysdig, Falco 
	* Runtimes: gvisor (experiment in Leo ATM), Kata, Firecracker
	* image scanning → trivy (see above, main item)
	* Image signing: Notary, ContentTrust
	* Docker API: Twistlock probably the only one worth it
	* Service Mesh: Istio, Envoy
	* CIS: CIS benchmark docker, DevSec image framework

**How Can We Do Better?**

The process would go like: Scan the image when a new change is pushed, and prevent the image from being pushed to the container registry if a vulnerability is detected. This ensures that the vulnerable images are never available to be deployed.

Other potential tools/ideas:
Quay:[https://quay.io/](https://quay.io/)
Anchore:[https://anchore.io/](https://anchore.io/)
Docker Bench Test:[https://github.com/alexei-led/docker-bench-test](https://github.com/alexei-led/docker-bench-test)
RArchitecture:[https://success.docker.com/article/security-best-practices](https://success.docker.com/article/security-best-practices)
Falco:[https://sysdig.com/opensource/falco/](https://sysdig.com/opensource/falco/)
Dagda:[https://github.com/eliasgranderubio/dagda/](https://github.com/eliasgranderubio/dagda/)

{% endtab %}
{% endtabs %}