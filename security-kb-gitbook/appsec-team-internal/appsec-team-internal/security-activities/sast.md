# SAST

{% tabs %}
{% tab title="Code Repository Management" %}
## Code Repository Management

**Description:**

Monitor Github for secrets checking and other anomalous behavior.

**Tools:**

* Git Secrets:[https://github.com/awslabs/git-secrets](https://github.com/awslabs/git-secrets)
* Protected Branches:[https://help.github.com/articles/about-protected-branches/](https://help.github.com/articles/about-protected-branches/)
* Pullapprove:[https://www.pullapprove.com/](https://www.pullapprove.com/)
* Git-secrets client-side protection
* TruffleHog/Gitrob as a server-side protection 

**How Can We Do Better?**

Is it widely used? How can we detect that it's being used?

Zybjana Bedo has setup jenkins jobs

Discussion with GitGuardian Split jenkins jobs into smaller ones Zybjana Bedo
{% endtab %}

{% tab title="Static Code Analysis" %}
## Static Code Analysis

**Description:**

Static Code Analysis is an activity that is performed continuously and aims to identify issues at a code level.

**Tools:**

* Codacy:[https://app.codacy.com/organization/BroadInstitute](https://app.codacy.com/organization/BroadInstitute)

**How Can We Do Better?**
{% endtab %}

{% tab title="Third-Party Libraries" %}
## Third-Party Libraries

**Description:**

Third-party libraries have several interesting risks. Obviously, vulnerabilities can be introduced into libraries and we need to ensure that our developers are aware when such things happen.

**Third-Party Component Remediation Procedure:**

Currently, Sourceclear is our source of truth for open source and third-party vulnerability scanning.

1. SourceClear identifies a vulnerable library in your project. Sourceclear then sends a report to Broad's Sourceclear database. See "Sourceclear Scanning" below. 
2. Security engineers see the vulnerability report and work with developers to assess the risk by reaching out to the project's security champion on Slack. Vulnerabilities are then classified as "High", "Medium", or "Low" severity based on how the library is used and the vulnerability itself. 
3. Developers create a remediation plan. Usually, this simply means updating the library to a version that is currently identified as "safe". Based on severity, vulnerabilities must be mitigated within a certain timeline:
   * `High` - Fixed within 30 days
   * `Medium` - Fixed within 90 days
   * `Low` - Fixed within 180 days

**Sourceclear Scanning**

Sourceclear scans projects by cloning the project repo, identifying the package manager, building the project, and examining third party code. It also looks at indirect dependencies. [78% of vulnerabilities](https://snyk.io/blog/78-of-vulnerabilities-are-found-in-indirect-dependencies-making-remediation-complex/) came from indirect dependencies in 2018.

You may need to customize Sourceclear scans by adding a `srcclr.yml` file to your project's root directory. The `srcclr.yml` file contains scan directives that determine the scan settings for your repo. For example, Sourceclear uses Python2.7 by default, but a `srcclr.yml` file can set the scanner to use Python3, if your project requires it.

### **Github Alerts**

All DataBiosphere repos currently have Vulnerability Alerts and Automated Security Fixes enabled. If you'd like to verify they have been enabled for a specific repository visit:   [https://github.com/DataBiosphere/{repository}/network/alerts](https://github.com/DataBiosphere/%7Brepository%7D/network/alerts)\*\*\*\*

**Procedure**

1. Github detects a vulnerable dependency and creates an issue under the Alerts tab of the repository. 
2. Github creates a pull request with the security fix. Tests are automatically run on the PR.
3. Developers review and merge the security fix.

**Tools:**

* SourceClear:[https://broadinstitute-dsp.sourceclear.io/login](https://broadinstitute-dsp.sourceclear.io/login)
* Dependabot: Enabled via Github
* Snyk
* Github Vulnerability Alerts - [Link](https://help.github.com/en/github/managing-security-vulnerabilities/viewing-and-updating-vulnerable-dependencies-in-your-repository)
* Github Automated Security Fixes - [Link](https://help.github.com/en/github/managing-security-vulnerabilities/configuring-automated-security-updates)
* Jenkins SourceClear Trigger job - [seceng-source-code-scan-setup](https://fc-jenkins.dsp-techops.broadinstitute.org/view/Security%20Scans/job/seceng-source-code-scan-setup/)
* Jenkins SourceClear Scanner job - [seceng-srcclr-scan](https://fc-jenkins.dsp-techops.broadinstitute.org/view/Security%20Scans/job/seceng-srcclr-scan/)
* SourceClear Scanner Docker image - [repo](https://github.com/broadinstitute/sourceclear-scanner-docker)
* SourceClear Scanner Docker image - [GCR](https://console.cloud.google.com/gcr/images/dsp-appsec-dev/US/srcclr_scanner?project=dsp-appsec-dev&organizationId=548622027621&gcrImageListsize=30)

**How Can We Do Better?**

More automated triage; currently a robust process
{% endtab %}

{% tab title="Docker" %}
## Docker

**Description:**

Need to analyze containers for security issues. Must Integrate into our CI/CD pipeline to ensure that only images that meet your security and compliance requirements are deployed.

**Tools:**

* Trivy:[https://github.com/knqyf263/trivy](https://github.com/knqyf263/trivy) \(For docker image scanning via ci/cd. In progress by Albano Drazhi.\)

Docker Other, FYI David Bernick Zybjana Bedo. Add if I missed something about the following areas. This does not involve Kubernetes stuff which of course has gotten a bit complex in general and security is a big contributor to this complexity.

* User Namespaces
* Syscalls: SecComp, Sysdig, Falco 
* Runtimes: gvisor \(experiment in Leo ATM\), Kata, Firecracker
* image scanning → trivy \(see above, main item\)
* Image signing: Notary, ContentTrust
* Docker API: Twistlock probably the only one worth it
* Service Mesh: Istio, Envoy
* CIS: CIS benchmark docker, DevSec image framework

**How Can We Do Better?**

The process would go like: Scan the image when a new change is pushed, and prevent the image from being pushed to the container registry if a vulnerability is detected. This ensures that the vulnerable images are never available to be deployed.

Other potential tools/ideas:

* Quay:[https://quay.io/](https://quay.io/)
* Anchore:[https://anchore.io/](https://anchore.io/)
* Docker Bench Test:[https://github.com/alexei-led/docker-bench-test](https://github.com/alexei-led/docker-bench-test)
* RArchitecture:[https://success.docker.com/article/security-best-practices](https://success.docker.com/article/security-best-practices)
* Falco:[https://sysdig.com/opensource/falco/](https://sysdig.com/opensource/falco/)
* Dagda:[https://github.com/eliasgranderubio/dagda/](https://github.com/eliasgranderubio/dagda/)
{% endtab %}
{% endtabs %}

