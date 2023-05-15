# IAM

### Basic Principles

Use an approach of "least privilege".

* Only give users the permissions necessary to perform the tasks they **need** to perform.
* Avoid giving project-level or owner-level permissions if possible.

:closed\_lock\_with\_key:Develop and maintain a IAM review process so that you make sure that the right people, groups and service accounts have necessary permissions only.

#### Broad Accounts

Sometimes, Broad accounts (@broadinstitute.org) require project level permissions. This is acceptable only if they are really required.&#x20;

If you need to manage many broad accounts with similar permissions in a project or across different projects, we recommend requesting a [google group ](https://broad.service-now.com/now/nav/ui/classic/params/target/kb\_view.do%3Fsys\_kb\_id%3D1204fdc847d2e9d011484438946d4379)and adding all the broadies into that group and then assigning that group the required permissions.&#x20;

#### Non Broad accounts

Non-broad accounts sometimes need access to our GCP projects since we work in a collaborative space. Non-broad accounts should be given resource specific permission like storage admin, compute admin, etc.&#x20;

:closed\_lock\_with\_key:Non Broad accounts should never be added as `Project Editors` or `Project Owners` or `Security Admin`.&#x20;

NOTE: If a non-broad account needs over permissive roles like Editor, please contact <mark style="color:blue;">infosec@broadinstitute.org</mark> for help.

#### Service Accounts

* Use separate service accounts for all services. Make sure each service account only has the permissions necessary to do its job.
  * If using Service Accounts, the keys generated should be kept in a VERY safe place and rotated at least yearly.
  * Delete Service Accounts that you have not used in more than 30 days.

### IAM Tools to help you

#### IAM Recommender

The IAM Recommender is a feature that tells you if you’ve given people too broad permissions.&#x20;

* Log into **Google Cloud Console** -> **IAM\&Admin** -> **IAM** and see the “light bulb” in your interface. You can click that and right-size people’s permissions.

#### Project Recommendations

You can also access Project level IAM recommendations:

* &#x20;Log into **Google Cloud Console** -> **Cloud Overview** -> **Recommendations** -> Change project-level IAM role grants

:closed\_lock\_with\_key:The `Recommendations` tab has different recommendation views for different resources. We encourage you to review them and apply those that are useful to you and your team.&#x20;

#### Policy Analyzer

Policy Analyzer lets you find out which principals (for example, users, service accounts, groups, and domains) have what access to which Google Cloud resources based on your [IAM allow policies](https://cloud.google.com/iam/docs/policies). To access it

* Log into **Google Cloud Console** -> **IAM\&Admin** -> **Policy Analyzer**

Policy Analyzer can help you answer questions like these:

* Who can access this IAM service account?
* Who can read data in this BigQuery dataset that contains personally identifiable information (PII)?
* What roles and permissions does the`[google group]` group have on any resource in this project?
* What Compute Engine virtual machine (VM) instances can Tal delete in project A?
* Who can access this Cloud Storage bucket at 7 PM?

Here is [Google KB ](https://cloud.google.com/policy-intelligence/docs/policy-analyzer-overview)for more details about this tool

![](https://lh4.googleusercontent.com/jHdPCTzEcLCL8hGNOcDty6LXjJVyekF1FV-UlH4vG8AprmUkb7JMXFErdNmYVozD8Nkltx8j7BfrBf65bgH3tytA15jyTS14HQv5aqGrkwumHzwWfcgXPritJBexWEElefwOmw7Z)

###
