---
description: Static Application Security Testing
---

# SAST

**Description:**

Static Application Security Testing (SAST) uses static source code analysis to identify issues at a code level. 

Terra services must run SAST as part of their automated build process. Issues identified in a PR build can be addressed without waiting for later detection by a security team. Even better, IDE plugins are available so that developers can find and address issues prior to even pushing them to a branch.

**Onboarding SAST Tools**

DSP AppSec can assist in setting up service GitHub repos to be scanned via
the appropriate SAST tool(s). At a high level, this involves some simple 
edits to the build (for example, adding steps to GitHub Actions workflows) 
and adding secrets to the secret store for the repo. AppSec will set up 
the scanning working with the team to set up the scan. The team will 
usually need to address an initial batch of findings the come out of the
first scan.

**Process Requirements**

Services *must* enable SAST tools to run at a minimum on push and merge to main or master, and *must* display results with the continuous integration build results (e.g. GitHub Pull Request checks). Because it's easiest to fix things early and harder to fix code after deployment, service developers *should* resolve any issues flagged in pull requests prior to merging. Developers *should*
also use IDE plugins to detect and resolve issues as early as possible.

Service READMEs *may* display a badge as a live indicator of the status of SAST scan results of the codebase.

**Resolving SAST Findings**

Findings in a repo's main branch *must* be resolved within standard time limits according to severity -- 30 days from discovery for High; 90 days from discovery for Moderate; 180 days from discovery for Low. For erroneous findings (false positives or incorrect severities), developers can make adjustments with justification. AppSec can review these adjustments and make final decisions about severity
and correctness of findings.

**Non-Security Findings**

Code quality and coverage issues are reported by SAST tools. These issues
*should* be reviewed by developers and teams may find that the issues are 
helpful in improving the code. But these issues do not result in a failure from a reporting perspective are not required to be fixed according to security policy. 

**Automated Tools**

The current requirement is to use either Codacy or SonarCloud with results
visible in CI build results.

* Codacy - [https://app.codacy.com/](https://app.codacy.com) may be used for Java, Scala, NodeJS, and Python for the near future
* SonarCloud - [https://sonarcloud.io](https://sonarcloud.io) should be used for Java, Scala, NodeJS, and Python

New services should use SonarCloud. Services currently using Codacy or not displaying results with built results will be moved to SonarCloud by the end of 2022.  

**Ongoing Improvements**

AppSec continuously improves the SAST tooling and configuration in reaction
to industry trends, publicized vulnerabilities, and new capabilities that
become available.

Additional scans using spotbugs with find-sec-bugs, semgrep, and other source code tools are used by 
AppSec during manual code review in conjunction with penetration testing or threat modeling engagements. Over time, some of these tools will be  required build steps.