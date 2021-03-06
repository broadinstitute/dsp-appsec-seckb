---
description: Documentation of the Terra kernel stack deployment POC
---

# Terra Framework Deployment

### [Quickstarts](https://broadworkbench.atlassian.net/wiki/spaces/DEV/pages/226263044/Framework+Quickstarts)

Some recipes for getting started

## Infrastructure - Terraform <a id="Infrastructure---Terraform"></a>

Terraform spec for configuring the GKE cluster and network

### Spec <a id="Spec"></a>

Contained in the [terra-kernel-k8s profile in the terraform-terra repo](https://github.com/broadinstitute/terraform-terra). It uses the CIS-compliant Terraform modules for the [master](https://github.com/broadinstitute/terraform-shared/tree/master/terraform-modules/k8s-master) and [node pools](https://github.com/broadinstitute/terraform-shared/tree/master/terraform-modules/k8s-node-pool).

### Deployment <a id="Deployment"></a>

Currently the deployment is manual, and leverages the [profile-based deployment pattern](https://github.com/broadinstitute/dsp-k8s-deploy). This is an internal Broad pattern/tool, and its use for this stack is temporary while a more portable pattern is developed or the internal tooling is deemed fit for public use.

## k8s Cluster Configuration - Helm <a id="k8s-Cluster-Configuration---Helm"></a>

This layer is for configuration of the k8s cluster that is not service-specific, such as various cluster-wide settings and resources shared by all services.

### Spec <a id="Spec.1"></a>

The k8s cluster configuration is captured in the [terra-kernel Helm chart in the terra-helm repo](https://github.com/broadinstitute/terra-helm/tree/master/charts/terra-kernel). The values overrides for each kernel cluster live in YAML files in the [kernel folder of the terra-helm-definitions repo](https://github.com/broadinstitute/terra-helm-definitions/tree/master/kernel).

### Deployment <a id="Deployment.1"></a>

Currently the deployment is manual, and involves invoking helm on the [terra-kernel Helm chart](https://github.com/broadinstitute/terra-helm/tree/master/charts/terra-kernel) and a [values override file](https://github.com/broadinstitute/terra-helm-definitions/tree/master/kernel). Some options being considered for an automated CD flow for this configuration include [Argo](https://argoproj.github.io/argo-cd/) and [GitHub actions](https://github.com/features/actions).

## Java Service <a id="Java-Service"></a>

### Code <a id="Code"></a>

The POC service Java code lives in the [kernel-service-poc repo](https://github.com/DataBiosphere/kernel-service-poc)

### k8s Deployment <a id="k8s-Deployment"></a>

All k8s configuration YAMLs are also located in the [kernel-service-poc repo](https://github.com/DataBiosphere/kernel-service-poc), but are in [kustomize base format](https://github.com/kubernetes-sigs/kustomize#2-create-variants-using-overlays), meaning they need to be combined with an environment-specific overlay before they can be applied.

### Configuration <a id="Configuration"></a>

Any environment-specific configuration should be pulled out into kustomize overlays, and committed to the corresponding service’s configuration repo. The configuration repo for the POC service is [kernel-service-poc-config](https://github.com/DataBiosphere/kernel-service-poc-config/).

## Secrets - Vault and k8s secrets <a id="Secrets---Vault-and-k8s-secrets"></a>

In the Broad, we use Vault for secrets, but we don’t want to force that choice onto the kernel framework. The pattern we’re currently following is to give the CI\(currently GitHub Actions\) Vault approle credentials, enabling it to create a temporary token and load any required secrets from Vault into k8s-native secret resources.

