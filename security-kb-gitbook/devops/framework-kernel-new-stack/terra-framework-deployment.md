---
description: Documentation of the Terra kernel stack deployment POC
---

# Terra Framework Deployment

### [Quickstarts](framework-quickstarts.md) - Some recipes for getting started

## Infrastructure - Terraform <a id="Infrastructure---Terraform"></a>

Terraform spec for configuring the GKE cluster and network

### Spec <a id="Spec"></a>

Contained in the [terra-kernel-k8s profile in the terraform-terra repo](https://github.com/broadinstitute/terraform-terra). It uses the CIS-compliant Terraform modules for the [master](https://github.com/broadinstitute/terraform-shared/tree/master/terraform-modules/k8s-master) and [node pools](https://github.com/broadinstitute/terraform-shared/tree/master/terraform-modules/k8s-node-pool).

### Deployment <a id="Deployment"></a>

Currently the deployment is manual, and leverages the [profile-based deployment pattern](https://github.com/broadinstitute/dsp-k8s-deploy). This is an internal Broad pattern/tool, and its use for this stack is temporary while a more portable pattern is developed or the internal tooling is deemed fit for public use.

The current plan is to make it a vanilla Terraform repo deployed with [Atlantis](https://www.runatlantis.io/).

## k8s Cluster Configuration - Helm <a id="k8s-Cluster-Configuration---Helm"></a>

This layer is for configuration of the k8s cluster that is not service-specific, such as various cluster-wide settings and resources shared by all services.

### Spec <a id="Spec.1"></a>

The k8s cluster configuration is captured in the [terra-kernel Helm chart in the terra-helm repo](https://github.com/broadinstitute/terra-helm/tree/master/charts/terra-kernel). The values overrides for each kernel cluster live in YAML files in the [kernel folder of the terra-helm-definitions repo](https://github.com/broadinstitute/terra-helm-definitions/tree/master/kernel).

### Deployment <a id="Deployment.1"></a>

Currently the deployment is manual, and involves invoking helm on the [terra-kernel Helm chart](https://github.com/broadinstitute/terra-helm/tree/master/charts/terra-kernel) and a [values override file](https://github.com/broadinstitute/terra-helm-definitions/tree/master/kernel). Some options being considered for an automated CD flow for this configuration include [Flux](https://fluxcd.io/) [Argo](https://argoproj.github.io/argo-cd/) and [GitHub actions](https://github.com/features/actions).

## Java Services <a id="Java-Service"></a>

### Code <a id="Code"></a>

The POC service Java code lives in the [kernel-service-poc repo](https://github.com/DataBiosphere/kernel-service-poc)

### k8s Resources <a id="k8s-Deployment"></a>

All k8s configuration YAMLs live in the same repo, but are in [kustomize base format](https://github.com/kubernetes-sigs/kustomize#2-create-variants-using-overlays), meaning they need to be combined with an environment-specific overlay before they can be applied.

### Deployment flow for pushes to master

1. New commit is merged to master
2. [The master\_push workflow](https://github.com/DataBiosphere/kernel-service-poc/blob/gm-deployment/.github/workflows/master_push.yml) is triggered. It builds the image, tags the image & commit, and pushes the image to GCR. It then sends a [dispatch](https://help.github.com/en/actions/reference/events-that-trigger-workflows#external-events-repository_dispatch) with the new version for the service to the [framework-version repo](https://github.com/DataBiosphere/framework-version).
3. This triggers the [update workflow](https://github.com/DataBiosphere/framework-version/blob/master/.github/workflows/update.yml), which updates the JSON that maps services to versions to map to the new version for the service whose repo sent the dispatch. The JSON is then committed and pushed.
4. This triggers the [tag workflow](https://github.com/DataBiosphere/framework-version/blob/master/.github/workflows/tag.yml), which tags the new commit in the framework-version repo with a bumped semantic version, yielding a new version of the whole stack incorporating the newly available version of the service.
5. The new commit corresponding to the above version of the stack is now visible on the [deliverybot dashboard](https://app.deliverybot.dev/DataBiosphere/framework-version/branch/master). It can now be manually selected for deployment to an environment.
6. Deploying a version of the stack to an environment from the dashboard triggers the [deploy workflow](https://github.com/DataBiosphere/framework-version/blob/master/.github/workflows/deploy.yml). This sends a dispatch to the [framework-env repo](https://github.com/DataBiosphere/framework-env) with the version that the chosen commit is tagged with, and the desired environment.
7. The dispatch triggers the [update workflow in that repo](https://github.com/DataBiosphere/framework-env/blob/master/.github/workflows/update.yml), which similarly to the one in the framework-version one, updates a JSON. This JSON maps environments to versions of the stack. It is updated to reflect the desired deployment of the new stack version to the specified environment and the change is pushed up.
8. The change to the JSON triggers the [apply workflow](https://github.com/DataBiosphere/framework-env/blob/master/.github/workflows/apply.yml), which actually deploys the desired resources to k8s. It determines the services that must be updated by diffing the stack versions that the environment in question is transitioning between and re-deploys the services that need updates.

### Configuration <a id="Configuration"></a>

Any environment-specific configuration should be pulled out into kustomize overlays, and committed to the corresponding service’s configuration repo. The configuration repo for the POC service is [kernel-service-poc-config](https://github.com/DataBiosphere/kernel-service-poc-config/).

## Secrets - Vault and k8s secrets <a id="secrets"></a>

In the Broad, we use Vault for secrets, but we don’t want to force that choice onto the kernel/framework. The pattern we’re currently following is to give the CI\(currently GitHub Actions\) Vault approle credentials, enabling it to create a temporary token and load any required secrets from Vault into k8s-native secret resources.

The translation from Vault to k8s secrets is handled via the [secrets-manager CRD/application](https://github.com/tuenti/secrets-manager).

### Vault - source of truth inside Broad

Curently all framework-related secrets live under the following path: `secret/dsde/terra/kernel`

Engineers in the 

They are then namespaced by:

1. The k8s cluster name
2. The environment name
3. The service, if any

Some examples:

* A secret for the **kernel-service-poc** service in the **dev** environment/namespace of the **terra-kernel-k8s** cluster will live in: `secret/dsde/terra/kernel/terra-kernel-k8s/dev/kernel-service-poc/[secret name]`
  * Secrets can be further organized into logical folders, for example all secrets concerning DB connections can go inside a further folder called `db`
* Secrets that may be used by any service in the dev environment of the cluster can live under: 

  `secret/dsde/terra/kernel/terra-kernel-k8s/dev/common/[secret name]`

* Similarly, secrets that may be used by services/configurations in any environment can live under: 

  `secret/dsde/terra/kernel/terra-kernel-k8s/common/[secret name]`

### k8s secrets translation via [secrets-manager](https://github.com/tuenti/secrets-manager)

Secrets are translated from Vault to k8s by defining secrets-manager resources. These should be defined in either the env-base repo if the secret is shared by multiple services, or in the respective service repo. Based on whether the secret value changes from one environment/namespace to another, it should be defined in either the base kustomization or the overlay in the corresponding configuration repo.

Some examples:

{% tabs %}
{% tab title="specific to service+env" %}
```yaml
# From  kernel-service-poc-config/gmalkov/secrets.yaml:
apiVersion: secrets-manager.tuenti.io/v1alpha1
kind: SecretDefinition
metadata:
  name: secretdefinition-kernel-service-poc-postgres-db-name
spec:
  name: kernel-service-poc/postgres-db-name
  keysMap:
    db-name:
      path: secret/dsde/terra/kernel/terra-kernel-k8s/gmalkov/kernel-service-poc/postgres-db-name
      key: name
```
{% endtab %}

{% tab title="common to all envs" %}
```yaml
# From  env-base/config/secrets.yaml
apiVersion: secrets-manager.tuenti.io/v1alpha1
kind: SecretDefinition
metadata:
  name: secretdefinition-common-postgres-name
spec:
  name: postgres-cloudsql-instance-name
  keysMap:
    name:
      path: secret/dsde/terra/kernel/terra-kernel-k8s/common/postgres/instance
      key: name
```
{% endtab %}
{% endtabs %}

### Secret creation

Currently required secrets need to be manually created in Vault for each environment. A useful snippet for copying secrets:

```bash
docker run --rm --cap-add IPC_LOCK -e "VAULT_TOKEN=$(cat ~/.vault-token)" -e "VAULT_ADDR=https://clotho.broadinstitute.org:8200" vault:1.1.0 vault read --format=json [from_path] | jq .data > secret.json
docker run --rm --cap-add IPC_LOCK -e "VAULT_TOKEN=$(cat ~/.vault-token)" -e "VAULT_ADDR=https://clotho.broadinstitute.org:8200" -v $(pwd):/current vault:1.1.0 vault write [to_path] @/current/secret.json
```

