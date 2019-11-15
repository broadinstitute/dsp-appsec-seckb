---
description: Securing git and github
---

# Git/Github

## Securing Git

* [What to do when a secret is accidentally committed in source code?]()
* [How do I verify git-secrets works on my machine?]()
* [Manually installing git-secrets]()
* [Detecting commited secrets into git repositories - Server-Side]()
* [Repository Integrity With Signed Commits]()
* [References]()

Below are some items to consider in order to protect git repositories.

## What to do when a secret is accidentally committed in source code?

Secrets, such as private keys or API tokens, are regularly leaked by developers in source code repositories. More often than not this happens by accident. Accidents happen, however it's important that the necessary steps are taken as part of mitigation.

Examples of sensitive information:

* API tokens
* Private Keys
* GCP, AWS, Azure Keys
* Passwords, DB Credentials
* Confidential logs, etc.

### Post-incident step to take:

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

## How do I verify git-secrets works on my machine?

{% hint style="success" %}
**Step 1:** Verify package is installed git-secrets
{% endhint %}

{% hint style="success" %}
**Step 2:** Verify rules are enabled
{% endhint %}

## Manually installing git-secrets

To prevent any secrets that we might accidentally commit to the GitHub repository, we may want to use the git-secrets developed by the awslabs for our repository to keep safe during development.

The following snippet downloads, installs, and configures git-secrets for repositories initiated or cloned _in the future_.

```text
git clone https://github.com/awslabs/git-secrets.git
(cd git-secrets && sudo make install)
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets
git secrets --add --global 'BEGINPRIVATEKEY.*ENDPRIVATEKEY' # google private key pattern
git config --global init.templateDir ~/.git-templates/git-secrets
```

Now enable git-secrets for each _current_ repository with

```text
(cd path/to/my/repo && git secrets --install)
```

**GCP Example**

```text
{
  "type": "service_account",
  "project_id": "my_gcp_account_id",
  "private_key_id": "333d1d68bef68da9ec765f03c5d9bb3457ab92af",
  "private_key": "-----BEGINPRIVATEKEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAACFwAAAAdz\nNhAAAAAwEAAQAAAgEAtKqj5MX24mM+TaqUdK2h8tMDzOal/ScR9x4P7fHo77urCM\nhMAi07122VBmD9JB5BOX3Wo6xhaB3t9aKnTSShP736NXS8n7bQpq8deyn7UwCuwl\nOVBYSyb6NpwdsIVJ7/nPFz9jKPpPepMd5StJmr8V5rJTP9xFLFewcudyDNk32gv6\njWalhBVloppiKAExq+utChjkR3w4UvAlzmWOlhH/Gyqk1Dc4aKwm9yZAF+kJPtzQ\nCQyJogDbiGtmFwZVp/Bo+FM8qV3hEk7VKqXL91zhQaZ1YldNY31IoGdolj7tUg1I\nOMWGaZYzdiUGYHX6+ZyN//ndoCMNM2SBfHSp1pFi01H7SmyXsiDLSOQFjp9TBDeP\nMwPqUNKJ9+zevXLE2Qk4LxGW/M/Nbiu/OocdkPY8me7DzkgCiUYeoNNon7533THY\nGeH7XgZ70mJUTeakAEeEUa/0Jicp1lW7FFUutRYCRnzXFo2zpm3G2f3RXCwozeuw\n753YbRbU5F+PK7ZVDlXH2sUr4A1yIXCdnf6ubcsvp9h+slUv+Uae/sPrir1RI2Js\nBzcsoZ5FHp6FrmqyueRUbh/0nwLCOe+eZP4aJ9mNDG8nAtTDH2MhO8BrUWtwD9pJ\ncAAAdwShe7oEoXu6AAAAAHc3NoLXJzYQAAAgEAtKqj5MX24mM+TaqUdK2h8tMDzO\n9x4P7fHo77urCMBDh3uPhMAi07122VBmD9JB5BOX3Wo6xhaB3t9aKnTSShP736NX\npq8deyn7UwCuwl+4w5GNOVBYSyb6NpwdsIVJ7/nPFz9jKPpPepMd5StJmr8V5rJT\newcudyDNk32gv6/T7gaajWalhBVloppiKAExq+utChjkR3w4UvAlzmWOlhH/Gyqk\nwm9yZAF+kJPtzQjxVGFlCQyJogDbiGtmFwZVp/Bo+FM8qV3hEk7VKqXL91zhQaZ1\n3G2f3RXCwozeuwNaYh5c753YbRbU5F+PK7ZVDlXH2sUr4A1yIXCdnf6ubcsvp9h+\nae/sPrir1RI2Jsci97e0BzcsoZ5FHp6FrmqyueRUbh/0nwLCOe+eZP4aJ9mNDG8n\nMhO8BrUWtwD9pJDWmGZxcAAAADAQABAAACABXyOJB8v73GYnYax4fY47hUi7yjM/\ncabs4OfmOyOH/2wAxXFRyalA9aP2UT+QwfJLswHxeow/ha0mIpTPtg/Ll6gV9m+9\nJAGnGuF9Tr1L1WzkTGxu5xrR9EkX879SoaWmCdMAHzKGHYt9PX9uH7XNioKInPY/\nDVfpQy+sbg9681qRsMqGcoq18q+q40uKwZbpvQ5h8bEBVPI2O9Fzort2GjAZoQYq\nu5CMYex8G8HxWSdv4U8VF873HbPXoAIiAduxp36q1c6ZGdMYgmp402sL/Ez2RIIa\ndsGFdP85IpDNxe0EbtZqoCZJWZzHJjWXJfVabNrwrBmLpzc10VaiI4JBVj8zwOp7\nptZrhhAjLTt5kkWs00gHLLxOsC6Ni3Ni4BuvPFE8rs0svt1BONEmV1zeFHJWNKxE\nljZWFjY291bnQuY29tAQIDBAU=\n-----ENDPRIVATEKEY-----",
  "client_email": "my_gcp_email@my_gcp_account_id.iam.gserviceaccount.com",
  "client_id": "300698269862192074801",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my_gcp_email@my_gcp_account_id.iam.gserviceaccount.com"
}
```

**AWS Example**

```text
x ="AKIAABCDEFGHIJKLMNOP","H/A604MMvmQjLuZw/xxxxxxxxxxxxxxxxxxxxxxx"
```

## Detecting commited secrets into git repositories - Server-Side

For server-side detection of secrets we have implemented controls and as a developer the only thing you need to do is watch out for any alerts communicated by the DSP AppSec team as we closely monitor these alerts in case there's any accidental commit of secrets.

## Repository Integrity With Signed Commits

This is important because it helps ensure repository integrity. When someone has write access to a repository is is very easy to spoof commits pretending to be someone else. However there is also an external attack vector for those projects that accept PRs from outside collaborators. Example shown below.

**Scenario 1 - legit commit**

![Legitimate pull request](../../.gitbook/assets/legit-commit.png)

**Scenario 2 - spoofed commit from user who has access to repo** ![Spoofed commit from user with access](../../.gitbook/assets/fake-commit%20%281%29.png)

**Scenario 3 - spoofed commit via PR as an outside collaborator**

![Spoofed commit from outside collaborator](../../.gitbook/assets/outside-pr.png)

**Steps to follow to setup commit signing are located below.** Alternatively you can just run the following [script](https://github.com/broadinstitute/dsp-security-knowledgebase/blob/master/source/scripts/gitsign.sh). Please ensure you have [installed gpg](https://gpgtools.org/). prior to running the script.

* Generate a GPG key:

  [https://help.github.com/en/articles/generating-a-new-gpg-key](https://help.github.com/en/articles/generating-a-new-gpg-key)

* Add the GPG key to your github account:

  [https://help.github.com/en/articles/adding-a-new-gpg-key-to-your-github-account](https://help.github.com/en/articles/adding-a-new-gpg-key-to-your-github-account)

* Start signing commits:

  [https://help.github.com/en/articles/signing-commits](https://help.github.com/en/articles/signing-commits)

{% hint style="info" %}
**\(Recommended\)** Set up Automatic Signing To remove the hassle of always remembering to sign your commits, you can configure Git to sign all your commits automatically as you create them.

```text
git config –-global commit.gpgsign true
```
{% endhint %}

## References

* [https://cloudplatform.googleblog.com/2017/07/help-keep-your-Google-Cloud-service-account-keys-safe.html](https://cloudplatform.googleblog.com/2017/07/help-keep-your-Google-Cloud-service-account-keys-safe.html)
* [https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
* [https://mikegerwitz.com/2012/05/a-git-horror-story-repository-integrity-with-signed-commits](https://mikegerwitz.com/2012/05/a-git-horror-story-repository-integrity-with-signed-commits)

