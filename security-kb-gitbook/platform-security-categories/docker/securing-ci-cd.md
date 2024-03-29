---
description: Scan docker images in CI/CD pipeline using Trivy.
---

# Securing CI/CD

## Quick intro

A common risk in containerized environments is deploying containers having vulnerabilities. Static archive files that include all components to run an application, may be missing critical security updates, or are just outdated. For this reason, before pushing images to container registries and deploy them, DSP Appsec team highly recommends scanning images using Trivy tool.

Some of the image security issues are listed below:

{% hint style="danger" %}
**Image configuration defects**- images may also have configuration defects, for example when an image runs with greater privileges than needed, or when an image has an SSH daemon that exposes the container to unnecessary network risk.
{% endhint %}

{% hint style="danger" %}
**Embedded malware** - malicious files could be included within a container and be used to attack other containers or hosts within the environment. A possible source of this embedded malware is by the third party of which the full provenance is not known.
{% endhint %}

{% hint style="danger" %}
**Embedded clear text secrets** - when secrets are included in an image, they are directly into the image file system. Anyone with access to the image can easily read these secrets.
{% endhint %}

{% hint style="danger" %}
**Use of untrusted images** - using externally provided images results in risks such as introducing malware, leaking data, or including components with vulnerabilities.
{% endhint %}

### Trivy Setup

Below you will find examples on how to setup `trivy` using your CI tool.

{% hint style="info" %}
A job will be marked as **FAIL** if a _Critical_ vulnerability is detected.
{% endhint %}

{% tabs %}
{% tab title="Github Actions" %}
Add this step in your Github Action workflow to scan an image.

```
  - name: Scan image with Trivy
    uses: docker://aquasec/trivy
    with:
      args: --exit-code 1 --severity CRITICAL --no-progress ${IMAGE_NAME}
```

Examples for Github actions workflows: [https://github.com/broadinstitute/dsp-appsec-trivy-cicd/tree/master/.github/workflows](https://github.com/broadinstitute/trivy-cicd/tree/master/.github/workflows)
{% endtab %}

{% tab title="CircleCI" %}
Add these steps to your `config.yml` to install trivy and scan an image.

```
- run:
  name: Install trivy
  command: |
    apk add --update-cache --upgrade --update curl
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin
- run:
  name: Scan the local image with trivy 
  command: trivy --exit-code 1 --severity CRITICAL --no-progress ${IMAGE_NAME}:${CIRCLE_SHA1}
```

Examples for CircleCI workflows: [https://github.com/broadinstitute/dsp-appsec-trivy-cicd/tree/master/.circleci](https://github.com/broadinstitute/trivy-cicd/tree/master/.circleci)
{% endtab %}

{% tab title="TravisCI" %}
Include these steps to your `travis.yml` file to install Trivy and scan an image. \*\*\*\*

```
before_install:
    - docker build -t ${IMAGE_NAME}:${COMMIT} .
    - export VERSION=$(curl --silent "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    - wget https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz
    - tar zxvf trivy_${VERSION}_Linux-64bit.tar.gz
script:
    - ./trivy --exit-code 1 --severity CRITICAL --no-progress ${IMAGE_NAME}:${COMMIT}
```

TravisCI workflow example: [https://github.com/broadinstitute/dsp-appsec-trivy-cicd/tree/master/travis](https://github.com/broadinstitute/trivy-cicd/tree/master/travis)
{% endtab %}

{% tab title="Docker" %}
Test Trivy via Docker:

```
docker pull aquasec/trivy                                
```

Scan your image in MacOs

```
docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```

Scan your image on your host machine

```
 docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```

Scan your image with the cache directory on your machine.

```
docker run --rm -v [YOUR_CACHE_DIR]:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```
{% endtab %}
{% endtabs %}

### Mark an issue as False Positive

If you'd like to mark an issue as False Positive you can do so using the following steps in Trivy.

* [ ] Create `.trivyignore` file.
* [ ] Include vulnerabilities you want to mark as FP by adding them with their `VULNERABILITY ID` and commenting on the reason.

```
# This vulnerability doesn't have impact in our settings. 
CVE-2019-18276

#  This vulnerability doesn't have impact in our settings too.
CVE-2016-2779 
```

If your image is built via a script in a CI/CD tool (e.g Jenkins), please make sure to mount `.trivyignore` file.

Add `-v "$PWD/.trivyignore":/.trityignore:ro --ignorefile /.trivyignore`

```
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$HOME"/Library/Caches:/root/.cache/ -v "$PWD/.trivyignore":/.trivyignore:ro aquasec/trivy --exit-code 1 --severity CRITICAL --ignorefile /.trivyignore "$IMAGE_NAME":"$TAG"
```

**Example repository:** [**https://github.com/broadinstitute/dsp-appsec-trivy-cicd**](https://github.com/broadinstitute/trivy-cicd) \*\*\*\*

## AppSec team solution to protect CI/CD

Appsec team built its own **blessed images** that are scanned frequently. Created a Github Action which is integrated with all services reporitories and that action will check if they are using our blessed images, and if not the action will run Trivy against the base image.

Check this repository to learn more about [Appsec Trivy Action.](https://github.com/broadinstitute/dsp-appsec-trivy-action)

### Questions

Reach out to appsec@broadinstitute.org
