---
description: Scan docker images in CI/CD pipeline using Trivy.
---

# Securing CI/CD

## Quick intro

A common risk in containerized environments is deploying containers having vulnerabilities. Static archive files that include all components to run an application, may be missing critical security updates, or are just outdated. For this reason, before pushing images to container registries and deploy them, DSP Appsec team highly recommend to scan images using Trivy tool. 

### Trivy Setup

Below you will find examples on how to setup `trivy` using your CI tool. 

{% hint style="info" %}
A job will be marked as **FAIL** if a _Critical_ vulnerability is detected.   
{% endhint %}

{% tabs %}
{% tab title="Github Actions" %}
Add this step in your Github Action workflow to scan an image. 

```text
  - name: Scan image with Trivy
    uses: docker://aquasec/trivy
    with:
      args: --exit-code 1 --severity CRITICAL --no-progress ${IMAGE_NAME}
```

Examples for Github actions workflows: [https://github.com/broadinstitute/trivy-cicd/tree/master/.github/workflows](https://github.com/broadinstitute/trivy-cicd/tree/master/.github/workflows) 
{% endtab %}

{% tab title="CircleCI" %}
Add these steps to your `config.yml` to install trivy and scan an image. 

```text
- run:
  name: Install trivy
  command: |
    apk add --update-cache --upgrade --update curl
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin
- run:
  name: Scan the local image with trivy 
  command: trivy --exit-code 1 --severity CRITICAL --no-progress ${IMAGE_NAME}:${CIRCLE_SHA1}
```

Examples for CircleCI workflows: [https://github.com/broadinstitute/trivy-cicd/tree/master/.circleci](https://github.com/broadinstitute/trivy-cicd/tree/master/.circleci)
{% endtab %}

{% tab title="TravisCI" %}
Include these steps to your `travis.yml` file to install Trivy and scan an image. ****

```text
before_install:
    - docker build -t ${IMAGE_NAME}:${COMMIT} .
    - export VERSION=$(curl --silent "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    - wget https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz
    - tar zxvf trivy_${VERSION}_Linux-64bit.tar.gz
script:
    - ./trivy --exit-code 1 --severity CRITICAL --no-progress ${IMAGE_NAME}:${COMMIT}
```

TravisCI workflow example: [https://github.com/broadinstitute/trivy-cicd/tree/master/travis](https://github.com/broadinstitute/trivy-cicd/tree/master/travis)
{% endtab %}

{% tab title="Docker" %}
Test Trivy via Docker: 

```text
docker pull aquasec/trivy                                
```

Scan your image in MacOs

```text
docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```

Scan your image on your host machine

```text
 docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```

Scan your image with the cache directory on your machine.

```text
docker run --rm -v [YOUR_CACHE_DIR]:/root/.cache/ aquasec/trivy [YOUR_IMAGE_NAME]
```
{% endtab %}
{% endtabs %}

### Mark an issue as False Positive

If you'd like to mark an issue as False Positive you can do so using the following steps in Trivy.

* [ ] Create `.trivyignore` file in your home directory.
* [ ] Include vulnerabilities you want to mark as FP by adding them with their `VULNERABILITY ID` and commenting the reason. 

```text

# This vulnerability doesn't have impact in our settings. 
CVE-2019-18276

#  This vulnerability doesn't have impact in our settings too.
CVE-2016-2779 

```

\*\*\*\*

 **Example repository:** [**https://github.com/broadinstitute/trivy-cicd**](https://github.com/broadinstitute/trivy-cicd) ****

### Questions

Reach out to appsec@broadinstitute.org







