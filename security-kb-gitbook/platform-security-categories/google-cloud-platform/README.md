---
description: >-
  These are some best practices and recommendations for managing your GCP
  projects.
---

# Google Cloud Platform

## Basic security tasks

Make sure your gcloud command line tool is up to date and latest. It changes often.

## Embrace Google’s Pre-Built Environments

* Google App Engine \(GAE\) - If you’re running a web-based application, this is a good place to start
* Google Kubernetes Engine \(GKE\) - If you’re running a bunch of different applications that have been or will be dockerized, this is a good place to start
* Google Cloud Functions \(GCF\) - Serverless applications based on events from Google like “web request” or “new file in bucket”
* Try not to use GCE unless absolutely necessary -- there’s more to manage with security.

## Code Protection

1. Google is API and code-driven. Most of this code goes to github or something similar. People commit keys to github by accident and if the keys are public, that’s a problem.
2. [Git Secrets](https://github.com/awslabs/git-secrets) - install this to keep keys out of code
3. Use Protected Branches to make sure someone reviews code to double-check.
4. If you MUST put secrets in code, encrypt them first with Google KMS and make that key accessible only to certain Google Service Accounts.
   * [https://github.com/GoogleCloudPlatform/berglas](https://github.com/GoogleCloudPlatform/berglas) is a good way to handle it.

## Secure your Databases \(cloudsql\)

* Make sure all databases are blocked to the outside world \(default\)
* Use [SQL Proxy](https://cloud.google.com/sql/docs/mysql/sql-proxy) to ensure protected connections
* ONLY ALLOW SSL CONNECTIONS!

## IAM

* Use an approach of “least privilege” where users are granted only the permissions necessary to perform the tasks they need to perform.
  * Avoid giving Owner-level permissions if possible OR project-level permissions \(like editor\).
* If using Service Accounts, the keys generated should be kept in a VERY safe place, preferably Broad’s “Vault” and rotated at least yearly.
  * [https://opensource.google.com/projects/keyrotator](https://opensource.google.com/projects/keyrotator)

