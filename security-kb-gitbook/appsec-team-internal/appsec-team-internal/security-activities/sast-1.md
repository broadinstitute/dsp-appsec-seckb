---
description: Static Application Security Testing
---

# SAST

**Description:**

Static Application Security Testing (SAST) uses static source code analysis to identify issues at a code level.

Terra services must run SAST as part of their automated build process. Issues identified in a PR build can be addressed without waiting for later detection by a security team. Even better, IDE plugins are available so that developers can find and address issues prior to even pushing them to a branch.

**Onboarding SAST Tools**

DSP AppSec can assist teams in setting up services' GitHub repos to be scanned via the appropriate SAST tool(s). At a high level, this involves some simple edits to the build (for example, adding steps to GitHub Actions workflows) and adding secrets to the secret store for the repo. AppSec will set up the scanning working with the team to set up the scan. The team will usually need to address an initial batch of findings the come out of the first scan.

**Process Requirements**

Services _must_ enable SAST tools to run at a minimum on push and merge to main or master, and _must_ display results with the continuous integration build results (e.g. GitHub Pull Request checks). Because it's easiest to fix things early and harder to fix code after deployment, service developers _should_ resolve any issues flagged in pull requests prior to merging. Developers _should_ also use IDE plugins to detect and resolve issues as early as possible.

Service READMEs _may_ display a badge as a live indicator of the status of SAST scan results of the codebase.

**Resolving SAST Findings**

Findings in a repo's main branch _must_ be resolved within standard time limits according to severity -- 30 days from discovery for High; 90 days from discovery for Moderate; 180 days from discovery for Low. For erroneous findings (false positives or incorrect severities), developers can make adjustments with justification. AppSec can review these adjustments and make final decisions about severity and correctness of findings.

**Non-Security Findings and Adjacent Linters**

Static analysis is useful aside from security. Tools flag code quality and coverage issues. Teams are welcome to use these findings and other tools to manage that sort of issue, but AppSec and compliance do not impose requirements beyond addressing security issues. Many teams use other coverage or style checkers and they can use SAST tools to supplement, if desired.

**Automated Tools**

| Language   | Required Tool                       |
| ---------- | ----------------------------------- |
| Java       | SonarCloud (new projects) or Codacy |
| Scala      | Codacy                              |
| JavaScript | SonarCloud                          |
| Python     | SonarCloud                          |
| TypeScript | SonarCloud                          |
| Clojure    |                                     |
| Shell      | Codacy                              |

**SAST Configuration**

_**SonarCloud Scan Configuration**_

[SonarCloud](sonarcloud.io) must be configured with Analysis Method as CI, not Automatic Analysis. Each service should use the "Broad service way" quality gate. A badge is available for services' README.md.

_**Codacy Scan Configuration**_

The default rule set does not provide adequate security scanning, so [Codacy](https://app.codacy.com) must be configured to "Run analysis on your build server" and the SpotBugs plugin with its find-sec-bugs plugin must be added to the Codacy scan. Broad AppSec provides an [action](https://github.com/broadinstitute/dsp-appsec-sast) to easily follow that requirement within GitHub Actions.

Our Codacy license allows for a limited number of users, so we are unable to provide all developers with direct access to Codacy.

**Ongoing Improvements**

AppSec continuously improves the SAST tooling and configuration in reaction to industry trends, publicized vulnerabilities, and new capabilities that become available.

Additional scans using spotbugs with find-sec-bugs, semgrep, and other source code tools are used by AppSec during manual code review in conjunction with penetration testing or threat modeling engagements. Over time, some of these tools will be required build steps.
