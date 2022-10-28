---
description: Static Application Security Testing
---

# SAST

Static Application Security Testing (SAST) uses static source code analysis to identify issues at a code level.

Terra services must [enable SAST](sast-1.md#onboarding-sast-tools) as part of their automated build process. Issues identified in a PR build can be [resolved](sast-1.md#resolving-findings) without waiting for later detection by a security team.

IDE plugins are also available so that developers can find and address issues prior to even pushing them to a branch.

## **Onboarding**

DSP AppSec can assist teams in setting up services' GitHub repos to be scanned via the appropriate SAST tool(s):

1. Activate and configure the repo in [SonarCloud](sast-1.md#sonarcloud-configuration) or [Codacy](sast-1.md#codacy-scan-configuration).
2. Java only: set up [CI-based analysis](sast-1.md#java-sonarqube-ci-scan).&#x20;
3. Add a [badge](sast-1.md#badge) to your README.&#x20;

## Scanning Repositories

### Automation

SAST _must_ be enabled on push and on merge to main. Findings _must_ display results with the continuous integration build results (usually as GitHub Pull Request checks). Test code _may_ be excluded from scanning.

### Badge

Service READMEs _should_ display a badge as a live indicator of the status of SAST scan results of the codebase. You can obtain this from the SonarCloud repo Information page.

### **Tools**

| Language   | Required Tool                                                                                     |
| ---------- | ------------------------------------------------------------------------------------------------- |
| Java       | [SonarCloud](sast-1.md#sonarcloud-configuration) or [Codacy](sast-1.md#codacy-scan-configuration) |
| Scala      | [Codacy](sast-1.md#codacy-scan-configuration)                                                     |
| JavaScript | [SonarCloud](sast-1.md#sonarcloud-configuration) or [Codacy](sast-1.md#codacy-scan-configuration) |
| Python     | [SonarCloud](sast-1.md#sonarcloud-configuration) or [Codacy](sast-1.md#codacy-scan-configuration) |
| TypeScript | [SonarCloud](sast-1.md#sonarcloud-configuration)                                                  |
| Go         | [SonarCloud](sast-1.md#sonarcloud-configuration)                                                  |

## **Resolving Findings**

Dev teams _should_ fix any real issues flagged in pull requests prior to merging. Devs can also use IDE plugins to detect and resolve issues as early as possible. SonarLint is available for this purpose.

SonarCloud displays results in Pull Requests and provides links to details in SonarCloud.&#x20;

Findings (i.e. vulnerability issues and security hotspots) in a repo's main branch _must_ be resolved within standard time limits by severity -- 7 days from discovery for Critical; 30 days for High; 90 days for Moderate; 180 days for Low.

Resolution options:

* fix the code (vulnerability is real and exploitable, or developer wants to fix it)
* mark as False Positive (scanner was wrong)
* mark as Won't Fix (not exploitable vulnerability or low-risk code quality issue, and developer does not want to fix)

Real vulnerabilities must be fixed in code, but when appropriate, developers can mark findings in SonarCloud as False Positive or Won't Fix and provide a brief justification. AppSec can review these adjustments and make final decisions about severity and correctness of findings.

To mark a SonarCloud finding, first log in to SonarCloud as a GitHub repo member. Findings are visible even without being logged in, but in order to mark something, you must log in. Security Hotspots should be reviewed right away even if the code will not be fixed immediately. Contact AppSec with any questions.

## **SonarCloud Configuration**

1. Post on #dsp-infosec-champions that a repo requires SonarCloud. AppSec will help if needed.
2. Log in to [SonarCloud](https://sonarcloud.io) as a GitHub user who is a repo owner.
3. Add the repo to SonarCloud and configure as follows.
   1. Quality Gate: Broad service way or Broad&#x20;
   2. New Code: 30 days
   3. Analysis Method: Obtain token, build file templates, and project/org keys.
4. For non-Java projects, you're all set with SonarCloud Automatic Analysis.
5. For Java only, set up scanning in the build. See **Java SonarQube CI Scan** below. (For most languages other than Java, scanning is automatic with no build changes.)

## Java SonarQube CI Scan

For Java, you must modify the CI build to run the scan and disable Automatic Analysis.&#x20;

### Checklist

Assuming a GitHub actions gradle build, the task list is:

1. Enable scanning the repo in SonarCloud. From the SonarCloud repo Information page, obtain project key and organization key.
2. From the SonarCloud Administration, Analysis Method, obtain `SONAR_TOKEN` and add it to the repo via [Vault and Atlantis](https://docs.google.com/document/d/1JbjV4xjAlSOuZY-2bInatl4av3M-y\_LmHQkLYyISYns).
3. Scan from the build, typically from `build.gradle` and `build-and-test.yml`. The [Java template project](https://github.com/DataBiosphere/terra-java-project-template) is a good reference.
4. Return to SonarCloud, go to Administration, Analysis Method, and **disable Automatic Analysis**.

### **More Java CI Scan Details**

It's okay to scan only in `service` and `client` (omitting test code) but do ensure that `projectName` is specified. Also `projectKey` and `organization` must match SonarCloud. Here's a Gradle example. (Some projects put this in subdirectory `build.gradle` files and others use the root level.)

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

A GitHub action or other CI step must run the scan on push and PR. Many Java services have a `build-and-test.yml` workflow that scans the `service` subproject on `push` and `pull_request`. Do scan `client` as well, if applicable, or scan the entire repo. The `SONAR_TOKEN`secret must be added via Vault.

```
      - name: SonarQube scan
        run: ./gradlew --build-cache :service:sonarqube
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

must be configured with Analysis Method as CI, not Automatic Analysis. Each service should use the "Broad service way" quality gate. **** Optionally, a more stringent gate can be used to prohibit all bug findings.

## **Codacy Scan Configuration**

[Codacy](https://app.codacy.com) must be configured to "Run analysis on your build server," and the SpotBugs plugin with its find-sec-bugs plugin must be added to the Codacy scan.

Our Codacy license allows for a limited number of users, so we are unable to provide all developers with direct access to the Codacy portal, but talk to AppSec if you want access and do not already have it.

## **Ongoing Improvements**

AppSec continuously improves the SAST tooling and configuration in reaction to industry trends, publicized vulnerabilities, and new capabilities that become available.

Additional scans using spotbugs with find-sec-bugs, semgrep, and other source code tools are used by AppSec during manual code review in conjunction with penetration testing or threat modeling engagements. Over time, some of these tools will be required build steps. Teams _may_ use the [DSP AppSec SAST action](https://github.com/broadinstitute/dsp-appsec-sast) to perform additional checks.
