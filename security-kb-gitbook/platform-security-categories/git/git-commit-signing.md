---
description: Repository Integrity with signed commits
---

# Git Commit Signing

Signing git commits because it helps ensure repository integrity. When someone has write access to a repository is is very easy to spoof commits pretending to be someone else. However there is also an external attack vector for those projects that accept PRs from outside collaborators. Example shown below.

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

