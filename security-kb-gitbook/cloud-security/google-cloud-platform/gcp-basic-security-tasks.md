---
description: Starting a GCP project securely...
---

# Before Starting a Project

## Key Takeaways

* Make sure your gcloud command line tool is up-to-date.
* Embrace Google's pre-built environments.
* Make sure keys are used securely!

## Update gcloud

Make sure your gcloud command line tool is up to date and latest. It changes often.

```bash
# Check you current version of gcloud
gcloud version

# Update gcloud if necessary
gcloud components update

# Note: You may to authenticate/login again after updating
gcloud auth login
```

## Embrace Google's pre-built environments

| **Use** | **If your project...** |
| :--- | :--- |
| Cloud Functions | is written in Node.js, Python, or Go and can be triggered by an "event" \(like a Pub/Sub topic or HTTP request\). |
| App Engine | is a web-based application. |
| Compute Engine | has special infrastructure requirements. Don't use unless absolutely necessary. |
| GKE | has a bunch of different applications that have been Dockerized. |

### Security of GAE and Cloud Functions

Google manages the infrastructure security of applications run in App Engine and Cloud Functions, which minimizes our risk. Each week, Google applies software and OS updates to these environment, so you don't have to do anything!

## Code Protection in GCP

1. Just like Github, you should avoid putting keys or secrets in code hosted in Google Cloud. People commit keys to Github by accident and if the keys are public, that’s a problem. Make sure [git-secrets is installed](https://dsp-security.broadinstitute.org/platform-security-categories/git/setup-git-secrets) and use protected branches to make sure someone reviews code.
2. Service account keys should be kept in Vault and rotated at least yearly.
3. If you MUST put secrets in code, encrypt them first with Google KMS and only make that key accessible to certain Google Service Accounts. Instructions can be found [here](https://cloud.google.com/kms/docs/encrypting-application-data#create_an_encryption_key). 
4. Broad Infosec scans all repos that we know about \(anything under broadinstitute Github Org as well as DataBioSphere and HumanCellAtlas\) for secrets and will alert the committer.
   1. See [https://dependabot.com/\#how-it-works](https://dependabot.com/#how-it-works) for more information.

**Additional Reading**

* [b3rg1a$](https://github.com/GoogleCloudPlatform/berglas) - a command line tool and library for storing secrets in Google Cloud Platform

