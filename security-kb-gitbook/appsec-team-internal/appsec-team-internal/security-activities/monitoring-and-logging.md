# Monitoring and Logging

{% tabs %}
{% tab title="WAF" %}

**Description:**

Collect data from HTTP request processing, inside the application, in the browser – and aggregate and analyze in the cloud. The output is meaningful, actionable alerts on active attacks. 

**Tools:**
* TCell:[https://broadinstitute.tcell.io/#/login](https://broadinstitute.tcell.io/#/login)

**How Can We Do Better?**

Needs better tuning	

{% endtab %}
{% tab title="RASP" %}

**Description:**

We need to provide a precise picture of just how an attack against a given application would or would not be successful in realtime. 

**Tools:**

* TCell:[https://broadinstitute.tcell.io/#/login](https://broadinstitute.tcell.io/#/login)

**How Can We Do Better?**

Needs better tuning	

Need to explore solutions. What works in GAE and Scala? Google claims native WAF/RASP functionality is coming.

{% endtab %}
{% tab title="Cloud Tenant Config Management" %}

**Description:**

Ensures all Cloud configurations are monitored and alerted when a change has been made

**Tools:**
* Jenkins GCP Audit:[https://fc-jenkins.dsp-techops.broadinstitute.org/view/Security%20Scans/job/Security-gcp-audit/](https://fc-jenkins.dsp-techops.broadinstitute.org/view/Security%20Scans/job/Security-gcp-audit/)
* AWS:[https://aws.amazon.com/guardduty/](https://aws.amazon.com/guardduty/)

**How Can We Do Better?**

For Google, virtually nothing works. We are doing an EA of a product called guardian that isn't annouced.

For AWS, this should be configured: https://aws.amazon.com/guardduty/

{% endtab %}
{% tab title="Platform Logging" %}

**Description:**

Alerts/Anamolies for GCP from Google's Stackdriver Platform

**Tools:**
* SumoLogic:[https://service.sumologic.com/ui/](https://service.sumologic.com/ui/)

**How Can We Do Better?**

Needs to be tuned for alerting of anomalous behavior. A vendor is making a Redlock.io -like product for us called Guardian that should further enhance this.

{% endtab %}
{% tab title="Application Security Logging" %}

**Description:**

**Tools:**

* [https://logit.io/](https://logit.io/) for Firecloud logs

DDP logs go to Enterprise Splunk. Threat intel is applied but limited for custom applications. 

**How Can We Do Better?**

Needs to be tuned for alerting of anomalous behavior. Currently alerts if there are alot of 500s in a certain amount of time.

These are mostly Apache and JVM logs. Is there a better way to derive events from this?

{% endtab %}
{% tab title="Platform Security" %}

**Description:**

Alert when the Platform (GCP) has anomolous or bad changes

**Tools:**
* Redlock - implemented to alert on CIS Benchmark Level 1

* Google Cloud Security Console - Will deprecate Redlock and alerts will roll to SIEM.

**How Can We Do Better?**

{% endtab %}
{% endtabs %}