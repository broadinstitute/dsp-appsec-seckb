---
description: Docker related security tools
---

# Tools

### Docker Best Practices

When it comes to building docker images, no one knows what the requirements are better than you do. The following tips provide the most customization (at the cost of slightly more work from the developer, and then for any images built, AppSec can scan them automatically.

Important things to keep in mind when building docker images.

1. Minimal images: This decreases the attack surface
2. Separation of Build-time and Run-time dependencies
3. Consistent Builds
4. Build from things such as [`gcr.io/distroless/java:11`](http://gcr.io/distroless/java:11) or use [DSP AppSec blessed images](https://github.com/broadinstitute/dsp-appsec-blessed-images) and install only the packages/layers that you need

The best environment to ensure you're following best practices when working with Dockerfiles is your IDE

{% tabs %}
{% tab title="IDE/Linter" %}
{% hint style="info" %}
The first opportunity to detect bad practices when working with Dockers is on Developer's IDE (`Vscode`, `JetBrains`) through `Hadolint`. Check the Integrations section below to setup Hadolint both in your IDE/Code Editor as well as in your CI pipeline (CircleCI, Jenkins, Travis).
{% endhint %}

#### Editors

Using hadolint in your terminal is not always the most convenient way, but it can be integrated into your editor to give you a feedback as you write your `Dockerfile`.

| Editor         | Plugin                                                                                                                                                                                                                                                                                                                                                                |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **VSCode**     | Integration of [vscode-hadolint](https://marketplace.visualstudio.com/items?itemName=exiasr.hadolint) with [VS Code](https://code.visualstudio.com)                                                                                                                                                                                                                   |
| **Atom**       | Integration of [linter-hadolint](https://atom.io/packages/linter-hadolint) with [Atom](https://atom.io).                                                                                                                                                                                                                                                              |
| **Sublime**    | Integration of [SublimeLinter-contrib-hadolint](https://github.com/niksite/SublimeLinter-contrib-hadolint) with [Sublime Text](http://www.sublimetext.com).                                                                                                                                                                                                           |
| **Vim/NeoVim** | <p><em>Hadolint is used in two plugins:</em></p><ul><li><a href="https://github.com/vim-syntastic/syntastic">Syntastic</a> - syntax checking plugin for Vim created by Martin Grenfell.</li><li><a href="https://github.com/w0rp/ale">ALE</a> (Asynchronous Lint Engine) - plugin for providing linting in NeoVim and Vim 8 while you edit your text files.</li></ul> |
{% endtab %}

{% tab title="CI/CD" %}
Scanning an image build in Jenkins, Travis or CircleCI allows you to fail the build if a vulnerability or misconfiguration is detected.

### Integrating Tools

#### Codacy

[Codacy](https://www.codacy.com) automates hadolint code reviews on every commit and pull request, reporting code style and error prone issues. Please reach out to \<appsec@broadinstitute.org> for integration of your project with Codacy.

#### Travis CI

Integration with Travis CI requires minimal changes and adding less than two seconds to your build time.

```
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

#### GitHub Actions

For GitHub you can build on the existing docker image with debian to run through all the Dockerfiles in your repository and print out a list of issues. You can find an example implementation [here](https://github.com/cds-snc/github-actions/tree/master/docker-lint). Your workflow might look something like this (feel free to use the provided Docker image `cdssnc/docker-lint` or create your own):

```
workflow "Lint Dockerfiles" {
  on = "push"
  resolves = ["Lint all the files"]
}

action "Lint all the files" {
  uses = "docker://cdssnc/docker-lint"
}
```

#### Gitlab CI

For GitLab CI you need a basic shell in your docker image so you have to use the debian based images of hadolint.

Add the following job to your project's `.gitlab-ci.yml`:

```
lint_dockerfile:
  stage: lint
  image: hadolint/hadolint:latest-debian
  script:
    - hadolint Dockerfile
```

#### CircleCI

For CircleCI integration use the [docker orb](https://circleci.com/orbs/registry/orb/circleci/docker). Update your project's `.circleci/config.yml` pipeline (workflows version 2.1), adding the docker orb and you can call the job docker/hadolint:

```
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

#### Jenkins declarative pipeline

You can add a step during your CI process to lint and archive the output of hadolint

```
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

#### Bitbucket Pipelines

Create a `bitbucket-pipelines.yml` configuration file:

```
pipelines:
  default:
    - step:
        image: hadolint/hadolint:latest-debian
        script:
          - hadolint Dockerfile
```
{% endtab %}

{% tab title="Static Analysis" %}
* [Dockle](https://github.com/goodwithtech/dockle#installation)
* [Trivy](https://github.com/aquasecurity/trivy)
{% endtab %}

{% tab title="Runtime" %}
* Sysdig Falco
{% endtab %}
{% endtabs %}
