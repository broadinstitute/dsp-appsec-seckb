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

{% tab title="GKE Secrets" %}

{% endtab %}
{% endtabs %}

