---
description: What to do when a secret is accidentally committed in source code?
---

# Did you accidentally commit a secret?

## Background

Secrets, such as private keys or API tokens, are regularly leaked by developers in source code repositories. More often than not this happens by accident. Accidents happen, however it's important that the necessary steps are taken as part of mitigation.

Examples of sensitive information:

* API tokens
* Private Keys
* GCP, AWS, Azure Keys
* Passwords, DB Credentials
* Confidential logs, etc.

## How would I know if I accidentally committed a secret?

Someone from the appsec team will reach out to you a few seconds after an incident has happened. Server-side secret detection monitors this for **all repos** in the following Github orgs:

* [BroadInstitute](https://github.com/broadinstitute)
* [Databiosphere](https://github.com/broadinstitute)
* [Humancellatlas](https://github.com/broadinstitute)

## Post-incident step to take:

{% hint style="danger" %}
**Step 1**: First things first, rotate your credentials. Once you have pushed a commit to Github, you should consider any data it contains to be compromised.
{% endhint %}

{% hint style="danger" %}
**Step 2:**: Remove sensitive info from git history as well: [https://help.github.com/en/articles/removing-sensitive-data-from-a-repository](https://help.github.com/en/articles/removing-sensitive-data-from-a-repository)
{% endhint %}

{% hint style="danger" %}
**Step 3:** Review access logs to see if there was some suspicious activity. If you do find suspicious activity please reach out to appsec@broadinstitute.org.
{% endhint %}

Some secrets can lead to other secrets. E.g. Slack tokens can give access to messages and shared files generally containing other secrets. GitHub tokens can give access to private repositories also containing secrets. Depending on your findings, if part of your infrastructure or data has been further exposed, you may need to take additional mitigation actions.

