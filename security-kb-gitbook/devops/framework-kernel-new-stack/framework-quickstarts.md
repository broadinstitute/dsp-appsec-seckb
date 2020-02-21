---
description: >-
  This is a set of recipes for getting started with framework work, depending on
  how much infrastructure you want to create vs re-use.
---

# Framework Quickstarts

## Create a new Java service <a id="Create-a-new-Java-service"></a>

1. Request creation of code and configuration repositories for your service, templated from the POC [service](https://github.com/DataBiosphere/kernel-service-poc) and [config](https://github.com/DataBiosphere/kernel-service-poc-config) repos.
   1. Currently the place to do this is [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)
2. Make sure you are in the [terra-kernel GitHub team in the Data Biosphere org](https://github.com/orgs/DataBiosphere/teams/terra-kernel).
   1. If not, ask for an invite in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)
3. TODO

## Create a new namespaced environment in an existing cluster <a id="Create-a-new-namespaced-environment-in-an-existing-cluster"></a>

1. Create a new namespace in the cluster
   1. If you don’t have permission to do this, ask in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)
2. Create a new folder in the config repos of any services you’d like to be able to deploy to the environment.
3. 
## Create a new framework cluster <a id="Create-a-new-framework-cluster"></a>

1. Ask yourself if you really need a new cluster instead of deploying a new environment to an existing one
2. Create a DDO JIRA ticket for the creation of a new cluster
   1. Mention it in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)

