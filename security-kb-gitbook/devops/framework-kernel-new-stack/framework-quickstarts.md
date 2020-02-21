---
description: >-
  This is a set of recipes for getting started with framework work, depending on
  how much infrastructure you want to create vs re-use.
---

# Framework Quickstarts

## Create a new Java service <a id="Create-a-new-Java-service"></a>

1. Make sure you are in the [terra-kernel GitHub team in the Data Biosphere org](https://github.com/orgs/DataBiosphere/teams/terra-kernel).
   * If not, ask for an invite in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)
2. Request creation of code and configuration repositories for your service, templated from the POC [service](https://github.com/DataBiosphere/kernel-service-poc) and [config](https://github.com/DataBiosphere/kernel-service-poc-config) repos.
   * Currently the place to do this is [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)
3. Ensure folder\(s\) exist in the new service config repo for the environment\(s\) it needs to be deployed to.
4. Commits to master should trigger the deployment workflow
   * In case of issues/questions ask in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35) or [\#crossteam-kernel](https://broadinstitute.slack.com/archives/CSE5QE8AH)

## Create a new namespaced environment in an existing cluster \(currently [terra-kernel-k8s](https://console.cloud.google.com/kubernetes/clusters/details/us-central1-a/terra-kernel-k8s?project=terra-kernel-k8s&organizationId=548622027621)\) <a id="Create-a-new-namespaced-environment-in-an-existing-cluster"></a>

1. Create a new folder in the config repos of any services you’d like to be able to deploy to the environment.
   * The name of the folder will be the name of the environment and namespace in the cluster
2. Add an entry for the new environment to the [deliverybot configuration YAML](https://github.com/DataBiosphere/framework-version/blob/master/.github/deploy.yml)
   * This should result in the new environment appearing as a target for [deliverybot deployments](https://app.deliverybot.dev/DataBiosphere/framework-version/branch/master)

## Create a new framework cluster <a id="Create-a-new-framework-cluster"></a>

1. Ask yourself if you really need a new cluster instead of deploying a new environment to an existing one
2. Create a DDO JIRA ticket for the creation of a new cluster
   1. Mention it in [\#dsp-devops-champions](https://broadinstitute.slack.com/archives/CADM7MZ35)

