---
description: >-
  A set of best practices for using GitHub Actions in the Broad Institute and
  Data Biosphere GitHub orgs
---

# Github Actions

A set of best practices for using GitHub Actions in the [Broad Institute](https://github.com/broadinstitute) and [Data Biosphere](https://github.com/databiosphere) GitHub orgs

## Vetting Actions <a id="Vetting-Actions"></a>

Pending implementation of enforcement, before adding actions not maintained by GitHub or another trusted source, it is the engineer’s responsibility to make sure the action does not contain any malicious code and then fork the action into the Broad Institute org.

### Forking an action <a id="Forking-an-action"></a>

After it has been determined that an action is not malicious and needs to be forked to the broadinstitute org, if you do not have permission to do so, ask in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35).

After the action has been forked:

1. Remove any references to the original repo in the example workflow snippets in the README
2. [Add a tagging workflow](https://github.com/broadinstitute/repository-dispatch/commit/b2942f7810eaa5b54834876b9c302d8279f91d21) so that the action can be automatically versioned and tagged on commits to master
3. Add the action to the list of actions below

### Broad Institute Actions <a id="Broad-Institute-Actions"></a>

* [github-tag-action](https://github.com/broadinstitute/github-tag-action)
* [repository-dispatch](https://github.com/broadinstitute/repository-dispatch)

### Related articles <a id="Related-articles"></a>

* Page: [Best Practices / Guides](https://broadworkbench.atlassian.net/wiki/spaces/DEV/pages/228655105)
* Page: [GitHub Actions](https://broadworkbench.atlassian.net/wiki/spaces/DEV/pages/228687875/GitHub+Actions)
* Page: [Terra Framework Deployment](https://broadworkbench.atlassian.net/wiki/spaces/DEV/pages/213680129/Terra+Framework+Deployment)
* Page: [DevOps Onboarding Guide](https://broadworkbench.atlassian.net/wiki/spaces/DEV/pages/194773001/DevOps+Onboarding+Guide)

