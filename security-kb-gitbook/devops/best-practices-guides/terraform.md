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

TODO

### Configuring Atlantis to work with your Terraform repo

TODO

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

TODO



