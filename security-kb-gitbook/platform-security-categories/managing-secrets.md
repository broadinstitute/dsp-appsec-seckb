---
description: How to manage secrets
---

# Secrets Management

{% tabs %}
{% tab title="Circle CI" %}
## CircleCI

Safely store secrets using contexts, project environment variables, or third-party solutions such as Vault.

### Contexts

Contexts are groups of environment variables that can be shared across organizations. Organization administrators \(anyone who is an owner of a project in the organization on Github\) can restrict contexts to specific groups of people, based on Github teams.

### Project Environment Variables

Anyone with access to the project can add or delete environment variables.

1. In the CircleCI application, go to your project’s settings by clicking the gear icon next to your project.
2. In the Build Settings section, click on Environment Variables.
3. Click the 'Add Variable' button.
4. Enter the value and the key for your variable and click 'Add Variable'.
5. Use your new environment variables in your .circleci/config.yml file.

To change the value of an environment variable, you have to delete it and add it to the project again.

1. In the CircleCI application, go to your project’s settings by clicking the gear icon next to your project.
2. In the Build Settings section, click on Environment Variables.
3. Click the 'X' next to the variable you want to change.
4. Click 'Add Variable' to add the variable again.

### Orbs

CircleCI currently has a registry of "orbs" - pre-built commands and jobs that can be used for processes like signing into to GCP. Using certified orbs from the registry is recommended if possible.

Example:

```text
      version: 2.1
      orbs:
        gcp-cli: circleci/gcp-cli@1.0.0
      workflows:
        install_and_configure_cli:
          # optionally determine executor to use
          executor: default
          jobs:
            - gcp-cli/install_and_initialize_cli:
                context: myContext # store your gCloud service key via Contexts, or project-level environment variables
                google-project-id: myGoogleProjectId
                google-compute-zone: myGoogleComputeZone
```

### Accessing Vault

You can access Vault using Docker or the command line.

```text
  version: 2.1
  jobs:
    build:
      docker: 
        - image: circleci/node:4.8.2 # the primary container, where your job's commands are run
      steps:
        - checkout # check out the code in the project directory
        - run: vault read -format=json secret/secops >> config.json
```

### Security in Circle CI

Circle CI destroys containers and VMs after jobs are finished running.

The default behavior of Circle CI is to never pass secrets to forked pull requests. Running Circle CI processes on forked PR could expose sensitive data, so it should not be enabled.
{% endtab %}

{% tab title="Travis CI" %}
## Travis CI

### Setting Up Environment Variables

Travis CI has two methods for handling sensitive information. The first method encrypts sensitive data and adds the encrypted environment variable to the .travis.yml file. This means that when re-running the build in the future, the job will use the same data that was run with the original build. The second method, which is used for rotating credentials \(such as Vault tokens\) or credentials that may be updated, stores the data in the Repository Settings. When old builds are run, they will used the updated environment variables. If a variable has the same name in the Repository Settings and in the .travis.yml file, the variable in the .travis.yml file takes precedence.

**Method One: Static Sensitive Data**

You can use the `travis` gem to create an encrypted environment variable and add it to your travis.yml file.

1. If you don't have the `travis` gem, install it: `gem install travis`
2. Encrypt the variable: `travis encrypt MY_SECRET_ENV=super_secret --add env.global`
3. Commit the changes.

**Method Two: Use Repository Settings to create Environmental Variables**

1. To create an environmental variable, go to your repository on TravisCI.org. 
2. Click on the repository's "More Options -&gt; Settings" and scroll down to Environment Variables.
3. Choose a name for your environment variable \(such as VAULT\_TOKEN\) and add the value.
4. Make sure the `Display Value in Build Log` toggle is off \(you should see an 'X'\).
5. Optionally, you can specify which branches have access to this token.
6. Click `Add`.

When environment variables are changed \(for example, after generating new Vault tokens\), you have to manually update them in Travis.

1. Go to your project's repository page on TravisCI.org.
2. Click on the repository's "More Options -&gt; Settings" and scroll down to Environment Variables.
3. Delete the outdated environment variable.
4. Choose a name for your environment variable and add the value. The name should be the same.
5. Make sure the `Display Value in Build Log` toggle is off \(you should see an 'X'\).
6. Click `Add`.

Travis automatically filter secure environment variables and tokens that are longer than three characters at runtime, effectively removing them from the build log, displaying the string `[secure]` instead.

However, there are some actions which will bypass the filter and should be avoided:

* settings which duplicate commands to standard output, such as `set -x` or `set -v` in your bash scripts
* displaying environment variables, by running `env` or `printenv`
* printing secrets within the code, for example `echo "$SECRET_KEY"`
* using tools that print secrets on error output, such as `php -i`
* git commands like `git fetch` or `git push` may expose tokens or other secure environment variables
* mistakes in string escaping
* settings which increase command verbosity
* testing tools or plugins that may expose secrets while operating

Anyone that can push to a repository on GitHub can add or delete environment variables and trigger builds.

### Accessing Vault

After setting the `VAULT_TOKEN` environment variable, you can access secrets stored in Vault. Below are a few examples on using Vault in your Travis CI builds. Be careful to avoid exposing secrets in the build logs \(see above\).

**Example \#1: Install Vault Locally**

Download the Vault CLI and use it to access secrets in your Travis CI builds.

```text
language: python

before_install:
- sudo apt-get update && sudo apt-get -y install curl unzip
- sudo curl -O https://releases.hashicorp.com/vault/1.0.1/vault_1.0.1_linux_amd64.zip
- sudo unzip vault_1.0.1_linux_amd64.zip
- sudo mv vault /usr/local/bin

script:
- VALS="$(vault read -format=json secret/secops)"
```

**Example \#2: Use the dsde-toolbox docker image**

Use the DSDE Toolbox docker image to run Vault.

```text
language: ruby

services:
  - docker

before_install:
- docker pull broadinstitute/dsde-toolbox:dev

script:
-  docker run -it --rm \
    -v $HOME:/root \
    broadinstitute/dsde-toolbox:dev vault -format=json read path/to/secret >> config.json@deni
```
{% endtab %}

{% tab title="GKE" %}
## Google Kubernetes Engine \(GKE\)

### Service Account credentials

GKE apps can access Service Account credentials \(which are used to access other Google APIs and services\) through:

1. \(**best practice**\) [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/concepts/security-overview#workload_identity_recommended), if configured for the cluster and Pods.
2. \(_deprecated_\) Default or custom [Node Service Account](https://cloud.google.com/kubernetes-engine/docs/concepts/security-overview#node_service_account).
3. \(discouraged\) [Service Account Keys](https://cloud.google.com/kubernetes-engine/docs/concepts/security-overview#service_account_json_key). 

\(3\) is still being used in many examples from Google documentation, however it's not advisable, mainly because long-term credentials should be rotated on a regular basis, and it can be hard to configure that, while simpler alternatives \(1 and 2\) exist.

\(2\) and \(1\) allow for Service Account credentials to be discovered _**automatically**_ by Google client libraries, i.e. it's not necessary to "point" your app to a particular key location like in method \(3\). Just initialize [Google API SDK](https://cloud.google.com/apis/docs/cloud-client-libraries) for your language of choice, and the credentials will be "picked up" from the environment. 

\(2\) is simple, however in an environment with _multiple_ apps per cluster, it leads to over-granting of permissions for various apps and unnecessary sharing of permissions between them.

\(1\) is the new Google-recommended best practice, and is fairly straightforward to configure still. Please follow [this guide](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) on how to configure it.

### SSL certificates

GKE apps may present HTTPS endpoints using SSL certificates with:

1. \(**best practice**\) [Google-managed SSL certificates](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs).
2. \(**good practice**\) [Cert-manager](https://cert-manager.io/docs/installation/kubernetes/).
3. \(discouraged\) [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

Method \(3\) is still used by many, but it is not great by the same arguments as for storing Service Account keys. Simpler methods exist \(1 and 2\).

\(2\) can be used to _automatically_ provision and manage certs with Let's Encrypt \(or other providers\).

\(1\) also _automatically_ provisions and manages certs, but is more integrated with the GKE Ingress and GCP ecosystem in general. In some _limited_ cases \(e.g. wildcard certs\) it offers fewer features than \(2\), but the support is growing, including the recently added ability to manage _multiple_ domain names per certificate.

### Other long-term credentials

* Database passwords
* Third-party API keys
* Credentials for other cloud providers

Storing these securely in GKE can be accomplished with:

1. \(**best practice**\) [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/), optionally with [application-level encryption](https://cloud.google.com/kubernetes-engine/docs/how-to/encrypting-secrets).
2. \(**best practice**\) [Secret Manager](https://cloud.google.com/secret-manager/docs/quickstart).
3. \(**best practice**\) [Hashicorp Vault](https://docs.dsp-devops.broadinstitute.org/framework-kernel-new-stack/framework-deployment#secrets).
4. \(good practice\) [Cloud KMS](https://cloud.google.com/kms/docs/quickstart).
5. \(**best practice**\) Federated access.

Options \(1-3\) are best, since they offer both a _dedicated_ secrets storage medium, and _auditability_ of _individual_ secret management and access by default \([Kubernetes Secrets](https://cloud.google.com/kubernetes-engine/docs/how-to/audit-logging#enabling_data_access_logs), [Secret Manager](https://cloud.google.com/secret-manager/docs/audit-logging)\). 

Kubernetes Secrets is slightly easier to use in the default configuration, as it doesn't require modification of the existing application code. However, enabling application-level encryption requires more work. Use Secret Manager if you can modify the application code.

Option \(4\) is also good as a general secrets _encryption_ solution, however it doesn't enable audit at the individual secret level \(only at the _encryption key_ level\). Use it when other options are not available.

Option \(5\) may be possible for access to third-party APIs and other cloud providers, starting with only Google credentials. Setting them up depends on the particular service provider. [Here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html)'s an example for AWS.

### Short-term credentials

* Google OAuth, JWT and other temporary API tokens.
* Session cookies for web apps etc.

1. \(**best practice**\) Avoid handling of tokens explicitly in your code, unless your app authentication mechanism requires it. If possible, use [Cloud IAP](https://cloud.google.com/iap/docs/enabling-kubernetes-howto), [Istio/Envoy proxy](https://cloud.google.com/istio/docs/istio-on-gke/installing), [Cloud Endpoints](https://cloud.google.com/endpoints/docs/openapi/get-started-kubernetes-engine), or another application-level authentication proxy that handles token validation for your API.
2. \(**good practice**\) Use well-established libraries \(e.g. [Google libraries](https://developers.google.com/identity/sign-in/web/backend-auth), [JWT libraries](https://jwt.io/)\) if you have to validate the tokens or otherwise process them on the backend. Additionally, clear variables used to store them as soon as you are finished with them, to avoid accidental leakage through the logs, third-party libraries etc.

Don't store temporary tokens on a file system, in a database, or another long-term storage medium. Doing so unnecessarily increases the risk of secret leakage, even if for a short time. Solutions \(1\) and \(2\) both allow managing these credentials for you.
{% endtab %}
{% endtabs %}



