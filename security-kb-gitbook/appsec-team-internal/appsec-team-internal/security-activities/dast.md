# DAST

{% tabs %}
{% tab title="Dynamic Application Security Testing" %}
**Description:**

As a part of Terra’s development process, all services are routinely scanned for vulnerabilities. Automated tests are conducted against running applications in testing and development environments.

### Burp Automator

Automated pentests that leverage Selenium test traffic taken through burp by using the Burp Automator tool written internally as a Java extender for Burp.

### OWASP ZAProxy

The OWASP ZAProxy tool is used as part of weekly scans against dev environments. Findings are uploaded to a central database on CodeDx, where issues are triaged. CodeDx reports are uploaded to a GCS bucket and scan notifications are sent to a private Slack channel in Broad's workspace.

#### ZAProxy Scanning Process

1. A scan is initiated once a week by the `terra-automated-scan-setup` Jenkins job. This job triggers several `automated-security-report-generation` Jenkins jobs to run with given `PROJECT` and `URL` parameters. This job also creates a folders in the GCS buckets `raw-terra-compliance-zap-reports` and `triaged-terra-compliance-zap-reports`. The folder names correspond to the time the Jenkins job was run. **Note:** The `PROJECT` parameter corresponds to the project name on CodeDx and follows the `[PROJECT]-zap-scan format`. The `URL` parameter is the url to be scanned by the ZAP scanner.
2. Once the `automated-security-report-generation job` is started, a ZAP baseline scan is run using the `Zap2Docker` image from DockerHub. An OWASP ZAP report is created and stored in the `/reports` folder on Jenkins.
3. Jenkins downloads the latest version `codedx-api-wrapper` image from Broad’s Google Cloud Repository. The `codedx-api-wrapper` image is built and uploaded to GCR whenever code is pushed to the master branch of the `broadinstitute/codedx-api-wrapper-python` repository using Cloud Build triggers.
4. The `codedx-api-wrapper` image, given a project name and CodeDx API key, checks if there is a CodeDx project matching the given `PROJECT` parameter. If not, the wrapper creates a new project.
5. The  ZAP report is uploaded to the project on CodeDx using the `codedx-api-wrapper` image.
6. A notification is sent to the `automated-security-scans` channel on Slack when the ZAP report is uploaded.
7. The `codedx-api-wrapper` image downloads the raw report from CodeDx. The CodeDx raw report is uploaded to a folder in the `raw-terra-compliance-zap-reports` GCS bucket using service account credentials.
8. The `codedx-api-wrapper` image then performs partially automated triaging on vulnerabilities in CodeDx. 
9. The Jenkins job then downloads a PDF report with all triaged vulnerabilities from CodeDx. 
10. The CodeDx triaged report is uploaded to a folder in the `triaged-terra-compliance-zap-reports` GCS bucket using service account credentials.

#### Technologies Used

| **Technology** | **Description** |
| :--- | :--- |
| **Jenkins** | **Jenkins jobs are used to trigger other jobs and to run scripts** |
| **CodeDx** | **Vulnerability Database** |
| **OWASP ZAP** | **Docker image used to perform a security scan** |
| **Slack** | **Reports sent to \#automated-security-scans sing Slack API** |
| **CodeDx API Wrapper** | **Python API Client for CodeDx**  |

|  |
| :--- |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |
|  |

**Tools:**

* Burp Suite:[https://portswigger.net/burp](https://portswigger.net/burp)
* Burp Pro Automator:[https://github.com/broadinstitute/burp-automator](https://github.com/broadinstitute/burp-automator)
{% endtab %}

{% tab title="Dynamic Application Security Testing \(Manual\)" %}
**Description:**

No matter how good our automatic DAST testing is, it’s always good to take a step back and run a Pentest against an application, service, or system.

**Tools:**

* Burp Suite:[https://portswigger.net/burp](https://portswigger.net/burp)
* ZAP:[https://www.owasp.org/index.php/OWASP\_Zed\_Attack\_Proxy\_Project](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project)

**How Can We Do Better?**
{% endtab %}

{% tab title="Bug Bounty Program" %}
**Description:**

The main aspects here are working with external researchers, connecting them with a fix internally, and paying them or recognizing them.

**Tools:** No tools currently in use.

**How Can We Do Better?** Need to build a solid program on either HackerOne or BugCrowd. Albano tends to be on the HackerOne side.

HackerOne:[https://www.hackerone.com/](https://www.hackerone.com/) BugCrowd:[https://www.bugcrowd.com/](https://www.bugcrowd.com/) [https://www.hackerone.com/sites/default/files/2017-05/visualized-guide-to-bug-bounty-success-bbbfm.pdf](https://www.hackerone.com/sites/default/files/2017-05/visualized-guide-to-bug-bounty-success-bbbfm.pdf)
{% endtab %}

{% tab title="Kubernetes" %}
**Description:**

Our cluster is as secure as the system running it.

**Tools:**

* KubeHunter:[https://github.com/aquasecurity/kube-hunter](https://github.com/aquasecurity/kube-hunter)

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

* Qualys scans all IPs owned by Broad \(onprem and cloud\) and reports back to Qualys

**How Can We Do Better?**

Needs to also more comprehensively scan VirtualHosts for single-IP infrastructures/Load Balancers.
{% endtab %}
{% endtabs %}

## 



