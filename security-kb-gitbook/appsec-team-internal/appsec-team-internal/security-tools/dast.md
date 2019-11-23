# DAST 

{% tabs %}
{% tab title="Dynamic Application Security Testing (Auto)" %}

**Description:**

Automated pentests that leverage Selenium test traffic taken through burp by using the Burp Automator tool written internally as a Java extender for Burp.

**Tools:**
Burp Suite:[https://portswigger.net/burp](https://portswigger.net/burp)
Burp Pro Automator:[https://github.com/broadinstitute/burp-automator](https://github.com/broadinstitute/burp-automator)

**How Can We Do Better?**

{% endtab %}
{% tab title="Dynamic Application Security Testing (Manual)" %}

**Description:**

No matter how good our automatic DAST testing is, it’s always good to take a step back and run a Pentest against an application, service, or system. 

**Tools:**
Burp Suite:[https://portswigger.net/burp](https://portswigger.net/burp)
ZAP:[https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project)

**How Can We Do Better?**

{% endtab %}
{% tab title="Bug Bounty Program" %}

**Description:**

The main aspects here are working with external researchers, connecting them with a fix internally, and paying them or recognizing them. 

**Tools:**
No tools currently in use.

**How Can We Do Better?**
Need to build a solid program on either HackerOne or BugCrowd. Albano tends to be on the HackerOne side.

HackerOne:[https://www.hackerone.com/](https://www.hackerone.com/)
BugCrowd:[https://www.bugcrowd.com/](https://www.bugcrowd.com/)
[https://www.hackerone.com/sites/default/files/2017-05/visualized-guide-to-bug-bounty-success-bbbfm.pdf](https://www.hackerone.com/sites/default/files/2017-05/visualized-guide-to-bug-bounty-success-bbbfm.pdf)

{% endtab %}
{% tab title="Kubernetes" %}

**Description:**

Our cluster is as secure as the system running it. 

**Tools:**
KubeHunter:[https://github.com/aquasecurity/kube-hunter](https://github.com/aquasecurity/kube-hunter)

**How Can We Do Better?**

* Pentest
* Continuously

Currently we only use Google's GKE and all settings are aligned to CIS Images. No runtime docker protection. Google is coming out with something and we're on alpha when it comes out. If not sufficient, we will look at vendor.

* KubeHunter:[https://github.com/aquasecurity/kube-hunter](https://github.com/aquasecurity/kube-hunter)
* Aqua Security:[https://www.aquasec.com/](https://www.aquasec.com/)
* Anchore:[https://anchore.com/kubernetes/](https://anchore.com/kubernetes/)

{% endtab %}
{% tab title="VM Security" %}

**Description:**

Alerts for when VMs have vulnerabilities 

**Tools:**
Qualys scans all IPs owned by Broad (onprem and cloud) and reports back to Qualys

**How Can We Do Better?**

Needs to also more comprehensively scan VirtualHosts for single-IP infrastructures/Load Balancers.

{% endtab %}
{% endtabs %}