# DAST

{% tabs %}
{% tab title="Dynamic Application Security Testing" %}
**Description:**

As a part of Terra’s development process, all services are routinely scanned for vulnerabilities. Automated tests are conducted against running applications in testing and development environments.

### Burp Automator

Automated pentests that leverage Selenium test traffic taken through burp by using the Burp Automator tool written internally as a Java extender for Burp.

### OWASP ZAProxy

The OWASP ZAProxy tool is used as part of weekly scans against dev environments. Findings are uploaded to a central database on CodeDx, where issues are triaged. CodeDx reports are uploaded to a GCS bucket and scan notifications are sent to a private Slack channel in Broad's workspace.

#### Technologies Used

| **Technology** | **Description** |
| :--- | :--- |
| **Jenkins** | **Jenkins jobs are used to trigger other jobs and to run scripts** |
| **CodeDx** | **Vulnerability Database** |
| **OWASP ZAP** | **Docker image used to perform a security scan** |
| **Slack** | **Reports sent to \#automated-security-scans sing Slack API** |
| **CodeDx API Wrapper** | **Python API Client for CodeDx**  |

**Tools:**

* Burp Suite:[https://portswigger.net/burp](https://portswigger.net/burp)
* Burp Pro Automator:[https://github.com/broadinstitute/burp-automator](https://github.com/broadinstitute/burp-automator)
{% endtab %}

{% tab title="Dynamic Application Security Testing \(Manual\)" %}
**Description:**

No matter how good our automatic DAST testing is, it’s always good to take a step back and run a Pentest against an application, service, or system.

**Tools:**

* Burp Suite:[https://portswigger.net/burp](https://portswigger.net/burp)
{% endtab %}

{% tab title="VM Security" %}
**Description:**

Our virtual machines are scanned regularly and if security issues are found, they are reported and fixed within a certain time. 

**Tools:**

* Qualys tool scans all IPs owned by Broad \(on-prem and cloud\) and reports back to Qualys.
{% endtab %}
{% endtabs %}

## 



