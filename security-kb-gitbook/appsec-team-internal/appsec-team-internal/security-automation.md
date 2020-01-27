# Security Automation

## Automated Security Scanning with OWASP ZAProxy

#### Introduction

As a part of Terra’s development process, all services are routinely scanned for vulnerabilities. Findings are uploaded to a central database on CodeDx, where issues are triaged. Reports are uploaded to a GCS bucket and scan status is is sent to a private Slack channel in Broad's workspace.

#### Process

1. A scan is initiated once a week by the terra-automated-scan-setup Jenkins job. This job triggers several automated-security-report-generation Jenkins jobs to run with given PROJECT and URL parameters. This job also creates a folders in the GCS buckets "raw-terra-compliance-zap-reports" and "triaged-terra-compliance-zap-reports". The folder names correspond to the time the Jenkins job was run. Note: The PROJECT parameter corresponds to the project name on CodeDx and follows the \[PROJECT\]-zap-scan format. The URL parameter is the url to be scanned by the ZAP scanner.
2. Once the automated-security-report-generation job is started, a ZAP baseline scan is run using the Zap2Docker image from DockerHub. An OWASP ZAP report is created and stored in the /reports folder on Jenkins.
3. Jenkins downloads the latest version codedx-api-wrapper image from Broad’s Google Cloud Repository. The codedx-api-wrapper image is built and uploaded to GCR whenever code is pushed to the master branch of the broadinstitute/codedx-api-wrapper-python repository using Cloud Build triggers.
4. The codedx-api-wrapper image, given a project name and CodeDx API key, checks if there is a CodeDx project matching the given PROJECT parameter. If not, the wrapper creates a new project.
5. The  ZAP report is uploaded to the project on CodeDx using the codedx-api-wrapper image.
6. A notification is sent to the automated-security-scans channel on Slack when the ZAP report is uploaded.
7. The CodeDx raw report is uploaded to a folder in the "raw-terra-compliance-zap-reports" GCS bucket using service account credentials.
8. The codedx-api-wrapper then performs partially automated triaging on vulnerabilities in CodeDx. 
9. The Jenkins job then downloads a PDF report with all triaged vulnerabilities from CodeDx. 
10. The CodeDx triaged report is uploaded to a folder in the "triaged-terra-compliance-zap-reports" GCS bucket using service account credentials.

#### Technologies Used

<table>
  <thead>
    <tr>
      <th style="text-align:left"><b>Technology</b>
      </th>
      <th style="text-align:left"><b>Description</b>
      </th>
      <th style="text-align:left"><b>Links</b>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><b>Jenkins</b>
      </td>
      <td style="text-align:left"><b>Jenkins jobs are used to trigger other jobs and to run scripts</b>
      </td>
      <td style="text-align:left">
        <p><a href="https://fc-jenkins.dsp-techops.broadinstitute.org/view/Security%20Scans/job/automated-security-report-generation/"><b>Automatic Security Scan and  Report Generation</b></a><b><br /></b>
        </p>
        <p><a href="https://fc-jenkins.dsp-techops.broadinstitute.org/view/Security%20Scans/job/terra-automated-scan-setup/"><b>terra-automated-scan-setup</b></a>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>CodeDx</b>
      </td>
      <td style="text-align:left"><b>Vulnerability Database</b>
      </td>
      <td style="text-align:left"><a href="https://codedx101.dsp-techops.broadinstitute.org/codedx/projects/"><b>Broad CodeDx instance</b></a>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>OWASP ZAP</b>
      </td>
      <td style="text-align:left"><b>Docker image used to perform a security scan</b>
      </td>
      <td style="text-align:left"><a href="https://github.com/zaproxy/zaproxy"><b>ZAProxy Github</b></a>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>Slack</b>
      </td>
      <td style="text-align:left"><b>Reports sent to #automated-security-scans sing Slack API</b>
      </td>
      <td style="text-align:left"></td>
    </tr>
    <tr>
      <td style="text-align:left"><b>CodeDx API Wrapper</b>
      </td>
      <td style="text-align:left"><b>Python API Client for CodeDx </b>
      </td>
      <td style="text-align:left">
        <p><a href="https://github.com/broadinstitute/codedx-api-client-python"><b>CodeDx API Wrapper Github</b></a><b><br /></b>
        </p>
        <p><a href="https://console.cloud.google.com/gcr/images/dsp-appsec-dev/GLOBAL/codedx-api-wrapper?project=dsp-appsec-dev&amp;organizationId=548622027621&amp;gcrImageListsize=30"><b>Codedx-api-wrapper image on GCR</b></a>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>Script</b>
      </td>
      <td style="text-align:left"><b>Script run by Jenkins</b>
      </td>
      <td style="text-align:left"><a href="https://github.com/broadinstitute/dsp-security-zap-scans"><b>Script Github</b></a>
      </td>
    </tr>
  </tbody>
</table>

