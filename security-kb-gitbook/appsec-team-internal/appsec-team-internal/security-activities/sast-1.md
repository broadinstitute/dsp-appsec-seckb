---
description: Static Application Security Testing
---

# SAST

**Description:**

Static Application Security Testing (SAST) uses static source code analysis to identify issues at a code level.

Terra services must run SAST as part of their automated build process. Issues identified in a PR build can be addressed without waiting for later detection by a security team.

Even better, IDE plugins are available so that developers can find and address issues prior to even pushing them to a branch.

**Onboarding SAST Tools**

DSP AppSec assists teams in setting up services' GitHub repos to be scanned via the appropriate SAST tool(s).

1. AppSec activates and configures the repo in SonarCloud or Codacy.
2. Java only: set up CI-based analysis:
   1. Dev team or AppSec adds a reporting key to the repo via [Vault and Atlantis](https://docs.google.com/document/d/1JbjV4xjAlSOuZY-2bInatl4av3M-y\_LmHQkLYyISYns).
   2. Dev team or AppSec makes simple edits to the build (adding steps to GitHub Actions workflows and/or modifying existing build.gradle file).
3. Dev team or AppSec adds a status badge to the repo's README. (Recommended)
4. Dev team, with AppSec assistance as needed, analyzes and addresses initial findings the come out of the first scan.

**Process Requirements**

SAST _must_ be enabled on push and merge to main. Findings _must_ display results with the continuous integration build results (usually as GitHub Pull Request checks). Because it's easiest to fix things early and harder to fix code after deployment, dev teams _should_ resolve any issues flagged in pull requests prior to merging. Devs _should_ also use IDE plugins to detect and resolve issues as early as possible.

Service READMEs _may_ display a badge as a live indicator of the status of SAST scan results of the codebase.

Test code _may_ be excluded from scanning to reduce noise. For typical Terra Java services, only the `service` and `client` directories should be scanned but `integration` may be excluded if it generates excessive findings. For Java this configuration can be done in build.gradle files.

**Resolving SAST Findings**

Findings in a repo's main branch _must_ be resolved within standard time limits according to severity -- 7 days from discovery for Critical; 30 days for High; 90 days for Moderate; 180 days for Low.

For erroneous findings (false positives or incorrect severities), developers can make adjustments with justification. AppSec can review these adjustments and make final decisions about severity and correctness of findings.

In SonarCloud and Codacy, authenticate with GitHub as a repo member in order to review and mark Issues and Security Hotspots. Findings are visible even without being logged in, but in order to mark something, you must log in. Security Hotspots should be reviewed right away even if the code will not be fixed immediately. Contact AppSec with any questions.&#x20;

**Non-Security Findings and Adjacent Linters**

Static analysis is useful aside from security. Tools flag code quality and coverage issues. Teams are welcome to use these findings and other tools to manage that sort of issue, but AppSec and compliance do not impose requirements beyond addressing security issues. Many teams use other coverage or style checkers and they can use SAST tools to supplement, if desired.

**Automated Tools**

| Language   | Required Tool        |
| ---------- | -------------------- |
| Java       | SonarCloud or Codacy |
| Scala      | Codacy               |
| JavaScript | SonarCloud or Codacy |
| Python     | SonarCloud or Codacy |
| TypeScript | SonarCloud           |
| Go         | SonarCloud           |

**SAST Configuration**

_**SonarCloud Scan Configuration**_

[SonarCloud](https://sonarcloud.io) configuration checklist:

1. Project added in SonarCloud
   1. Quality Gate: Broad service way
   2. New Code: 30 days
   3. Analysis Method: Obtain token, build file templates, and project/org keys.
2. Build runs the scan. It's okay to scan only in `service` and `client` (omitting test code) but do ensure that `projectName` is specified. Also `projectKey` and `organization` must match SonarCloud. Here's a Gradle example. (Some projects put this in subdirectory `build.gradle` files and others use the root level.)

```clike
    plugins {
      id "org.sonarqube" version "3.4"
    }

    sonarqube {
      properties {
        property "sonar.projectName", "terra-drs-hub"
        property "sonar.projectKey", "DataBiosphere_terra-drs-hub"
        property "sonar.organization", "broad-databiosphere"
        property "sonar.host.url", "https://sonarcloud.io"
        property "sonar.sources", "src/main/java,src/main/resources/templates"
      }
    }
```

1. GitHub action or other CI step to run the scan on push and PR. Many Java services have a `build-and-test.yaml` workflow that scans the `service` subproject on `push` and `pull_request`. Do scan `client` as well, if applicable.

```
      - name: SonarQube scan
        run: ./gradlew --build-cache :service:sonarqube
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

must be configured with Analysis Method as CI, not Automatic Analysis. Each service should use the "Broad service way" quality gate. A badge is available for services' README.md.

_**Codacy Scan Configuration**_

[Codacy](https://app.codacy.com) must be configured to "Run analysis on your build server," and the SpotBugs plugin with its find-sec-bugs plugin must be added to the Codacy scan.

Our Codacy license allows for a limited number of users, so we are unable to provide all developers with direct access to the Codacy portal.

**Ongoing Improvements**

AppSec continuously improves the SAST tooling and configuration in reaction to industry trends, publicized vulnerabilities, and new capabilities that become available.

Additional scans using spotbugs with find-sec-bugs, semgrep, and other source code tools are used by AppSec during manual code review in conjunction with penetration testing or threat modeling engagements. Over time, some of these tools will be required build steps. Teams _may_ use the [DSP AppSec SAST action](https://github.com/broadinstitute/dsp-appsec-sast) to perform additional checks.
