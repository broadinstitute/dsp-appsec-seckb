---
description: And how do we use it?
---

# What is SCA?

SCA is a category of tools that are used to find third party dependencies used by a project that contain known vulnerabilities. The tools usually focus on CVEs, while also provided premium findings that they have found their analysing open source library repos. \
CVEs have been reported by researchers, their details are available to the public and they are assigned an ID for easy reference. This ID is their CVE number, and is assigned and cataloged by Mitre. [https://cve.mitre.org](https://cve.mitre.org)

NIST also maintains a public database of CVE called the [NVD](https://nvd.nist.gov). Both Mitre's and NISTs sites contain similar data, however the NVD is usually used as the core reference site. A finding on the NVD will have a description, a [severity](https://nvd.nist.gov/vuln-metrics/cvss), a list of references, a category from the [CWE](https://cwe.mitre.org), and a list of known affected software. This is the information that Appsec uses to determine if a finding is relevant to a particular project.&#x20;

All SCA findings for a repo are best seen as potential risks and not imminent threats. When possible the safest approach is to update the dependencies affected, however software is complicated and that isn't always easy or possible. In those cases findings can be reviewed to determine if they affect the service as it is written and deployed. This review can be done either on a call with a member of Appsec, or by asking them to review the finding. If we are reviewing it on our own, we may need additional context concerning how the library is used. The easiest way to ask for a review is through our slack channel #dsp-infosec-champions.

High severity findings go through a review automatically as they are discovered. Once triaged they are either marked as ignored, or a ticket is opened with the appropriate team for remediation. The tickets for high findings will have a due date 30 days from discovery.

