---
description: Starting a GCP project securely...
---

# GCP Basic Security Tasks

## Key Takeaways

* Make sure your gcloud command line tool is up-to-date.
* Make sure users only have necessary permissions \(avoid giving "Owner" or "Editor" permissions\).
* Make sure keys are used securely!

## Update gcloud

Make sure your gcloud command line tool is up to date and latest. It changes often.

```text
# Check you current version of gcloud
gcloud version

# Update gcloud if necessary
gcloud components update

# Note: You made to authenticate/login again after updating
gcloud auth login
```

## IAM and Service Accounts

* Use an approach of "least privilege".
  * Only give users the permissions necessary to perform the tasks they **need** to perform.
  * Avoid giving project-level or owner-level permissions if possible.
* Use separate service accounts for all services. Make sure each service account only has the permissions necessary to do its job.

## Keys in GCP

1. Just like Github, you should avoid putting keys or secrets in code hosted in Google Cloud. Make sure [git-secrets is installed](https://dsp-security.broadinstitute.org/platform-security-categories/git/setup-git-secrets) and use protected branches.
2. Service account keys should by kept in Vault and rotated at least yearly.
3. If you MUST put secrets in code, encrypt them first with Google KMS and only make that key accessible to certain Google Service Accounts. Instructions can be found [here](https://cloud.google.com/kms/docs/encrypting-application-data#create_an_encryption_key).

**Additional Reading**

* [b3rg1a$](https://github.com/GoogleCloudPlatform/berglas) - a command line tool and library for storing secrets in Google Cloud Platform

