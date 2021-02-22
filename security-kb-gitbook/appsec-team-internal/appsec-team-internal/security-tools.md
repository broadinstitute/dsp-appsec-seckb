# Security Tools

{% tabs %}
{% tab title="Component Analysis" %}
**Sourceclear**

Sourceclear scans our Github repositories and finds vulnerabilities in third-party libraries and modules.  AppSec team members work with developers to identify false positives and remediate any issues.

**Github Security Alerts**

Some repositories have Github security alerts set up to scan for vulnerable dependencies.

**Trivy**

Scans docker images for vulnerabilities in base images.
{% endtab %}

{% tab title="Code Analysis" %}
**Codacy**

Scans code for errors before allowing developers to merge with the master branch.

**Semgrep** 

An open-source static code analysis tool that scans repositories for insecure code. Semgrep tool is integrated via Github Actions.
{% endtab %}

{% tab title="Pentesting" %}
**Burp**

Burp is currently the main pentesting tool used for application testing. AppSec engineers use Burp's proxy to analyze and modify HTTP requests and responses. Burp has many built-in tools and extensions that allow testers to look for XSS, injection, and other vulnerabilities. Results of the scans are then uploaded to CodeDx and Defect Dojo \(see _Project Management_ tab.

**OWASP Zap**

OWASP Zap is an open-source pentesting tool with similar applications to Burp. Because Zap is open source, you can find a wider variety of tools available, such as a Zap CLI and docker image.
{% endtab %}

{% tab title="Project Management" %}
**Defect Dojo**

Defect Dojo currently contains documentation on various DSP projects and teams, including the Security Champion of each project. Data from the New Security Requirements form is used to create new products. 

**CodeDx**

CodeDx is our database of vulnerabilities found during pentesting. Scans from Burp, Zap and many other security tools can be automatically imported to a CodeDx project. CodeDx can then filter vulnerabilities based on type, severity, paths, etc., and generate reports that include data on the vulnerability and how to fix it.

**SDARQ**

When creating a new service, developers should fill out the new service security requirements form, which can be found [here](https://sdarq.dsp-appsec.broadinstitute.org/). Once the form is submitted, a notification is sent to a Slack and the answers are reviewed by the security team. The data is then used to create a new engagement in Defect Dojo, a Jira ticket in the team board with a security checklist, and a Jira ticket to the AppSec board for a threat model request.   
  
Sdarq and CIS Scanner \(a different service integrated to SDARQ\) assess the security posture of GCP projects. Devs must provide GCP project id, and Sdarq returns to devs scanner results. 
{% endtab %}

{% tab title="Sensitive Data" %}
Developers should avoid putting secret information in Github repos or Jenkins logs. To prevent this, we use Vault to securely store keys and other sensitive data used in the development and production environments, as well as protected branches and pull-approve on Github.

**Git Secrets**

Prevents developers from accidentally committing secrets to Github. See installation instructions [here](https://dsp-security.broadinstitute.org/platform-security-categories/git/setup-git-secrets)

**Trufflehog/Github Broad Secret Scanner**

Scan commits for service account keys, access keys, and other secrets, and reports them to \#github-security-alerts on Slack. See this [link](https://dsp-security.broadinstitute.org/platform-security-categories/git/what-to-do-in-case-of-an-incident) for what to do when a secret is committed.

**Vault**

Vault is used to securely store secrets and other sensitive data. See the [DSDE Toolbox](https://github.com/broadinstitute/dsde-toolbox#authenticating-to-vault) for more information.

**Secret Manager**

To learn more about Secret Manager follow this [link](https://cloud.google.com/secret-manager).
{% endtab %}
{% endtabs %}

