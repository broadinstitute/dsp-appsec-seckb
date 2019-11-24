---
description: Docker related security tools
---

# Tools

{% tabs %}
{% tab title="IDE/Linter" %}
## Why?

The first opportunity to detect bad practices when working with Dockers is on Developer's IDE \(Vscode, JetBrains\) through Hadolin. Check the Integrations section below to setup Hadolint both in your IDE/Code Editor as well as in your CI pipeline \(CircleCI, Jenkins, Travis\). 



## Integrating Hadolint

### Editors

Using hadolint in your terminal is not always the most convenient way, but it can be integrated into your editor to give you a feedback as you write your Dockerfile.

#### Atom

> Atom is a text editor that's modern, approachable, yet hackable to the core—a tool you can customize to do anything but also use productively without ever touching a config file.

Thanks to [lucasdf](https://github.com/lucasdf), there is an integration [linter-hadolint](https://atom.io/packages/linter-hadolint) with [Atom](https://atom.io/).

[![linter-hadolint-img](https://user-images.githubusercontent.com/18702153/33764234-7abc1f24-dc0b-11e7-96b6-4f08207b6950.png)](https://user-images.githubusercontent.com/18702153/33764234-7abc1f24-dc0b-11e7-96b6-4f08207b6950.png)

#### Sublime Text 3

> A sophisticated text editor for code, markup and prose.

Thanks to [niksite](https://github.com/niksite), there is an integration [SublimeLinter-contrib-hadolint](https://github.com/niksite/SublimeLinter-contrib-hadolint) with [Sublime Text](http://www.sublimetext.com/).

#### Vim and NeoVim

Hadolint is used in two plugins:

* [Syntastic](https://github.com/vim-syntastic/syntastic) - syntax checking plugin for Vim created by Martin Grenfell.
* [ALE](https://github.com/w0rp/ale) \(Asynchronous Lint Engine\) - plugin for providing linting in NeoVim and Vim 8 while you edit your text files.

#### VS Code

> Visual Studio Code is a lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux.

There is an integration [vscode-hadolint](https://marketplace.visualstudio.com/items?itemName=exiasr.hadolint) with [VS Code](https://code.visualstudio.com/), built by [ExiaSR](https://github.com/ExiaSR).

[![vscode-hadolint-gif](https://camo.githubusercontent.com/5fabe529eaa737a19e9145bf22afbe117331d7c7/68747470733a2f2f692e6779617a6f2e636f6d2f61373031343630636364646131336131613434396232633365386461343062632e676966)](https://camo.githubusercontent.com/5fabe529eaa737a19e9145bf22afbe117331d7c7/68747470733a2f2f692e6779617a6f2e636f6d2f61373031343630636364646131336131613434396232633365386461343062632e676966)

#### Geany

> Geany is a powerful, stable and lightweight programmer's text editor that provides tons of useful features without bogging down your workflow. It runs on Linux, Windows and MacOS is translated into over 40 languages, and has built-in support for more than 50 programming languages.

The following can be used as a [build action](https://www.geany.org/manual/current/index.html#build-menu-commands-dialog) to [lint](https://www.geany.org/manual/current/index.html#lint) Dockerfiles.

```text
if docker run --rm -i hadolint/hadolint < "%d/%f"
| sed -re 's|^/dev/stdin:([0-9]*)|%d/%f:\1:WARNING:|'
| grep -EC100 ':WARNING:' ; then exit 1 ; else exit 0 ; fi
```
{% endtab %}

{% tab title="CI/CD" %}


## Integrating Hadolint

### Codacy

[Codacy](https://www.codacy.com/) automates hadolint code reviews on every commit and pull request, reporting code style and error prone issues. Please reach out to &lt;appsec@broadinstitute.org&gt; for integration of your project with Codacy. 

### Travis CI

Integration with Travis CI requires minimal changes and adding less than two seconds to your build time.

```text
# Use container-based infrastructure for quicker build start-up
sudo: false
# Use generic image to cut start-up time
language: generic
env:
  # Path to 'hadolint' binary
  HADOLINT: "${HOME}/hadolint"
install:
  # Download hadolint binary and set it as executable
  - curl -sL -o ${HADOLINT} "https://github.com/hadolint/hadolint/releases/download/v1.16.0/hadolint-$(uname -s)-$(uname -m)"
    && chmod 700 ${HADOLINT}
script:
  # List files which name starts with 'Dockerfile'
  # eg. Dockerfile, Dockerfile.build, etc.
  - git ls-files --exclude='Dockerfile*' --ignored | xargs --max-lines=1 ${HADOLINT}
```

### GitHub Actions

For GitHub you can build on the existing docker image with debian to run through all the Dockerfiles in your repository and print out a list of issues. You can find an example implementation [here](https://github.com/cds-snc/github-actions/tree/master/docker-lint). Your workflow might look something like this \(feel free to use the provided Docker image `cdssnc/docker-lint` or create your own\):

```text
workflow "Lint Dockerfiles" {
  on = "push"
  resolves = ["Lint all the files"]
}

action "Lint all the files" {
  uses = "docker://cdssnc/docker-lint"
}
```

### Gitlab CI

For GitLab CI you need a basic shell in your docker image so you have to use the debian based images of hadolint.

Add the following job to your project's `.gitlab-ci.yml`:

```text
lint_dockerfile:
  stage: lint
  image: hadolint/hadolint:latest-debian
  script:
    - hadolint Dockerfile
```

### CircleCI

For CircleCI integration use the [docker orb](https://circleci.com/orbs/registry/orb/circleci/docker). Update your project's `.circleci/config.yml` pipeline \(workflows version 2.1\), adding the docker orb and you can call the job docker/hadolint:

```text
orbs:
  docker: circleci/docker@x.y.z
version: 2.1
workflows:
  lint:
    jobs:
      - docker/hadolint:
          dockerfile: path/to/Dockerfile
          ignore-rules: 'DL4005,DL3008'
          trusted-registries: 'docker.io,my-company.com:5000'
```

### Jenkins declarative pipeline

You can add a step during your CI process to lint and archive the output of hadolint

```text
stage ("lint dockerfile") {
    agent {
        docker {
            image 'hadolint/hadolint:latest-debian'
        }
    }
    steps {
        sh 'hadolint dockerfiles/* | tee -a hadolint_lint.txt'
    }
    post {
        always {
            archiveArtifacts 'hadolint_lint.txt'
        }
    }
}
```



### Bitbucket Pipelines

Create a `bitbucket-pipelines.yml` configuration file:

```text
pipelines:
  default:
    - step:
        image: hadolint/hadolint:latest-debian
        script:
          - hadolint Dockerfile
```
{% endtab %}

{% tab title="Static Analysis" %}

{% endtab %}

{% tab title="Runtime" %}

{% endtab %}
{% endtabs %}

{% tabs %}
{% tab title="IDE/Linter" %}
## Why?

The first opportunity to detect bad practices when working with Dockers is on Developer's IDE \(Vscode, JetBrains\) through Hadolin. Check the Integrations section below to setup Hadolint both in your IDE/Code Editor as well as in your CI pipeline \(CircleCI, Jenkins, Travis\). 



## Integrating Hadolint

### Editors

Using hadolint in your terminal is not always the most convenient way, but it can be integrated into your editor to give you a feedback as you write your Dockerfile.

#### Atom

> Atom is a text editor that's modern, approachable, yet hackable to the core—a tool you can customize to do anything but also use productively without ever touching a config file.

Thanks to [lucasdf](https://github.com/lucasdf), there is an integration [linter-hadolint](https://atom.io/packages/linter-hadolint) with [Atom](https://atom.io/).

[![linter-hadolint-img](https://user-images.githubusercontent.com/18702153/33764234-7abc1f24-dc0b-11e7-96b6-4f08207b6950.png)](https://user-images.githubusercontent.com/18702153/33764234-7abc1f24-dc0b-11e7-96b6-4f08207b6950.png)

#### Sublime Text 3

> A sophisticated text editor for code, markup and prose.

Thanks to [niksite](https://github.com/niksite), there is an integration [SublimeLinter-contrib-hadolint](https://github.com/niksite/SublimeLinter-contrib-hadolint) with [Sublime Text](http://www.sublimetext.com/).

#### Vim and NeoVim

Hadolint is used in two plugins:

* [Syntastic](https://github.com/vim-syntastic/syntastic) - syntax checking plugin for Vim created by Martin Grenfell.
* [ALE](https://github.com/w0rp/ale) \(Asynchronous Lint Engine\) - plugin for providing linting in NeoVim and Vim 8 while you edit your text files.

#### VS Code

> Visual Studio Code is a lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux.

There is an integration [vscode-hadolint](https://marketplace.visualstudio.com/items?itemName=exiasr.hadolint) with [VS Code](https://code.visualstudio.com/), built by [ExiaSR](https://github.com/ExiaSR).

[![vscode-hadolint-gif](https://camo.githubusercontent.com/5fabe529eaa737a19e9145bf22afbe117331d7c7/68747470733a2f2f692e6779617a6f2e636f6d2f61373031343630636364646131336131613434396232633365386461343062632e676966)](https://camo.githubusercontent.com/5fabe529eaa737a19e9145bf22afbe117331d7c7/68747470733a2f2f692e6779617a6f2e636f6d2f61373031343630636364646131336131613434396232633365386461343062632e676966)

#### Geany

> Geany is a powerful, stable and lightweight programmer's text editor that provides tons of useful features without bogging down your workflow. It runs on Linux, Windows and MacOS is translated into over 40 languages, and has built-in support for more than 50 programming languages.

The following can be used as a [build action](https://www.geany.org/manual/current/index.html#build-menu-commands-dialog) to [lint](https://www.geany.org/manual/current/index.html#lint) Dockerfiles.

```text
if docker run --rm -i hadolint/hadolint < "%d/%f"
| sed -re 's|^/dev/stdin:([0-9]*)|%d/%f:\1:WARNING:|'
| grep -EC100 ':WARNING:' ; then exit 1 ; else exit 0 ; fi
```
{% endtab %}

{% tab title="CI/CD" %}


## Integrating Hadolint

### Codacy

[Codacy](https://www.codacy.com/) automates hadolint code reviews on every commit and pull request, reporting code style and error prone issues. Please reach out to &lt;appsec@broadinstitute.org&gt; for integration of your project with Codacy. 

### Travis CI

Integration with Travis CI requires minimal changes and adding less than two seconds to your build time.

```text
# Use container-based infrastructure for quicker build start-up
sudo: false
# Use generic image to cut start-up time
language: generic
env:
  # Path to 'hadolint' binary
  HADOLINT: "${HOME}/hadolint"
install:
  # Download hadolint binary and set it as executable
  - curl -sL -o ${HADOLINT} "https://github.com/hadolint/hadolint/releases/download/v1.16.0/hadolint-$(uname -s)-$(uname -m)"
    && chmod 700 ${HADOLINT}
script:
  # List files which name starts with 'Dockerfile'
  # eg. Dockerfile, Dockerfile.build, etc.
  - git ls-files --exclude='Dockerfile*' --ignored | xargs --max-lines=1 ${HADOLINT}
```

### GitHub Actions

For GitHub you can build on the existing docker image with debian to run through all the Dockerfiles in your repository and print out a list of issues. You can find an example implementation [here](https://github.com/cds-snc/github-actions/tree/master/docker-lint). Your workflow might look something like this \(feel free to use the provided Docker image `cdssnc/docker-lint` or create your own\):

```text
workflow "Lint Dockerfiles" {
  on = "push"
  resolves = ["Lint all the files"]
}

action "Lint all the files" {
  uses = "docker://cdssnc/docker-lint"
}
```

### Gitlab CI

For GitLab CI you need a basic shell in your docker image so you have to use the debian based images of hadolint.

Add the following job to your project's `.gitlab-ci.yml`:

```text
lint_dockerfile:
  stage: lint
  image: hadolint/hadolint:latest-debian
  script:
    - hadolint Dockerfile
```

### CircleCI

For CircleCI integration use the [docker orb](https://circleci.com/orbs/registry/orb/circleci/docker). Update your project's `.circleci/config.yml` pipeline \(workflows version 2.1\), adding the docker orb and you can call the job docker/hadolint:

```text
orbs:
  docker: circleci/docker@x.y.z
version: 2.1
workflows:
  lint:
    jobs:
      - docker/hadolint:
          dockerfile: path/to/Dockerfile
          ignore-rules: 'DL4005,DL3008'
          trusted-registries: 'docker.io,my-company.com:5000'
```

### Jenkins declarative pipeline

You can add a step during your CI process to lint and archive the output of hadolint

```text
stage ("lint dockerfile") {
    agent {
        docker {
            image 'hadolint/hadolint:latest-debian'
        }
    }
    steps {
        sh 'hadolint dockerfiles/* | tee -a hadolint_lint.txt'
    }
    post {
        always {
            archiveArtifacts 'hadolint_lint.txt'
        }
    }
}
```



### Bitbucket Pipelines

Create a `bitbucket-pipelines.yml` configuration file:

```text
pipelines:
  default:
    - step:
        image: hadolint/hadolint:latest-debian
        script:
          - hadolint Dockerfile
```
{% endtab %}

{% tab title="Static Analysis" %}

{% endtab %}

{% tab title="Runtime" %}

{% endtab %}
{% endtabs %}



