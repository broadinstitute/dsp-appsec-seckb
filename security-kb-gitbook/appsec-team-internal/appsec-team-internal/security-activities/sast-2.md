---
description: Software Composition Analysis
---

# Third-Party Libraries

**Description:**

Third-party libraries have several interesting risks. Obviously, vulnerabilities can be introduced into libraries and we need to ensure that our developers are aware when such things happen.

**Third-Party Component Remediation Procedure:**

Currently, Sourceclear is our source of truth for open source and third-party vulnerability scanning.

1. SourceClear identifies a vulnerable library in your project. Sourceclear then sends a report to Broad's Sourceclear database. See "Sourceclear Scanning" below.\

2. Security engineers see the vulnerability report and work with developers to assess the risk by reaching out to the project's security champion on Slack. Vulnerabilities are then classified as "High", "Medium", or "Low" severity based on how the library is used and the vulnerability itself.\

3. Developers create a remediation plan. Usually, this simply means updating the library to a version that is currently identified as "safe". Based on severity, vulnerabilities must be mitigated within a certain timeline:
   * `High` - Fixed within 30 days
   * `Medium` - Fixed within 90 days
   * `Low` - Fixed within 180 days

**Sourceclear Scanning**

Sourceclear scans projects by cloning the project repo, identifying the package manager, building the project, and examining third party code. It also looks at indirect dependencies.

You may need to customize Sourceclear scans by adding a `srcclr.yml` file to your project's root directory. The `srcclr.yml` file contains scan directives that determine the scan settings for your repo. For example, Sourceclear uses Python2.7 by default, but a `srcclr.yml` file can set the scanner to use Python3, if your project requires it.

### **Github Alerts**

All DataBiosphere repos currently have Vulnerability Alerts and Automated Security Fixes enabled. If you'd like to verify they have been enabled for a specific repository visit:   [https://github.com/DataBiosphere/{repository}/network/alerts](https://github.com/DataBiosphere/%7Brepository%7D/network/alerts)****

**Procedure**

1. Github detects a vulnerable dependency and creates an issue under the Alerts tab of the repository.&#x20;
2. Github creates a pull request with the security fix. Tests are automatically run on the PR.
3. Developers review and merge the security fix.

**Tools:**

* SourceClear
* Dependabot: Enabled via Github
* Github Vulnerability Alerts - [Link](https://help.github.com/en/github/managing-security-vulnerabilities/viewing-and-updating-vulnerable-dependencies-in-your-repository)
* Github Automated Security Fixes - [Link](https://help.github.com/en/github/managing-security-vulnerabilities/configuring-automated-security-updates)
