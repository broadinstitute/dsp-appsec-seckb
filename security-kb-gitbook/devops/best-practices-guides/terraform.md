---
description: Best practices for Analysis Platform Terraform repos
---

# Terraform

## Atlantis

There are several reasons why it makes sense to use [Atlantis](https://www.runatlantis.io/) to apply our Terraform instead of applying it from our laptops:

* Much less likely to be impacted by networking issues and cause weird state/locking problems
* No need to copy sensitive secrets like powerful service accounts or Vault credentials to people's laptops, they can only be accessed by Atlantis
* Excellent GitHub PR integration/automation
* Not relying on Broad-specific bash or consul-template tooling to deploy the Terraform makes it much more portable and easy for people outside the Broad to grab and use

### DSP's Atlantis

Our Atlantis deployment runs in the [dsp-tools k8s cluster](https://console.cloud.google.com/kubernetes/clusters/details/us-central1-a/dsp-tools?project=dsp-tools-k8s), and is [deployed with Helm](https://github.com/broadinstitute/terra-helm-definitions/blob/master/dsp-tools/atlantis.yaml).

### Configuring Atlantis to work with your Terraform repo

* For now Terraform repos managed with Atlantis need to be in the DataBiosphere GitHub org. This will very soon be expanded to the BroadInstitute org as well.
* The Atlantis GCP service account must have owner rights to the project that you want to manage. This is accomplished by submitting a PR to the [terraform-dsp-tools-k8s Terraform repo](https://github.com/broadinstitute/terraform-dsp-tools-k8s), which is not managed by Atlantis and must be applied manually.
  * Specifically, any additional projects that will be managed by Atlantis need to get added to the list of projects in the `atlantis_managed_projects` variable in that configuration.
* Add an atlantis.yaml file at the root of your repo and configure your projects and workflows to correctly combine your workspaces & .tfvars files. See the [atlantis.yaml docs](https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html) and project structure section below.
* That should be it!

## Modules

When possible, pull out any Terraform definitions that are likely to be re-used often into [modules](https://www.terraform.io/docs/modules/index.html).

A bunch of modules used by DSP live in [the terraform-shared repo](https://github.com/broadinstitute/terraform-shared/).

### Adding modules to `terraform-shared`

TODO

## Project Structure

[A good overview of Terraform project structure philosophy is in the Terraform docs](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html). The following sections go into detail about some of the themes mentioned there:

### One Terraform project per app

Terraform configurations are meant to be modular & granular, not monolithic. We can see this from the poor performance of our giant terraform-firecloud configuration. Ideally the infrastructure for each application would live in a separate configuration with a separate state.

### Workspaces for environments

[Terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) are a way to namespace state for multiple deployments for a Terraform configuration. Having a [.tfvars file](https://www.terraform.io/docs/configuration/variables.html#variable-definitions-tfvars-files) for each workspace/environment, and the core configuration defined in a module that consumes these environment-specific variables is a Terraform-native way to achieve environment namespacing.

### All configurations are modules

Each configuration should be structured as a module containing all of the generic Terraform code, with any Broad-specific configuration like provider and backend settings pulled out into a definitions folder that calls the module from a `main.tf` file. This way it is easy for anyone outside the Broad to deploy the infrastructure for our applications by just referencing the module and defining their own provider/backend configuration.

### Examples

#### Folder Structure

Below is an example Terraform project folder structure that incorporates the above principles

```text
.
├─ atlantis.yaml
├─ foo-app-definitions
|  ├─ main.tf // Calls the module defined below
|  ├─ terraform.tf // Configures providers & backend
|  ├─ dev.tfvars
|  ├─ staging.tfvars
|  └─ prod.tfvars
├─ foo-app-module // Should be portable (not Broad-specific)
|  ├─ variables.tf
|  ├─ vm.tf
|  ├─ vault.tf
|  └─ stuff.tf
```

#### atlantis.yaml

An example `atlantis.yaml` file to go with the above project structure, defining the environment projects and instructing Atlantis to apply them in separate workspaces and with the correct .tfvars files.

```text
version: 3
projects:
- name: dev
  dir: foo-app-definitions
  workflow: dev
  workspace: dev
- name: staging
  dir: foo-app-definitions
  workflow: staging
  workspace: staging
- name: prod
  dir: foo-app-definitions
  workflow: prod
  workspace: prod
workflows:
  dev:
    plan:
      steps:
      - init
      - plan:
          extra_args: ["-var-file", "dev.tfvars"]
  staging:
    plan:
      steps:
      - init
      - plan:
          extra_args: ["-var-file", "staging.tfvars"]
  prod:
    plan:
      steps:
      - init
      - plan:
          extra_args: ["-var-file", "prod.tfvars"]
```



