---
description: 'Resources on how to harden a base OS such as Debian9, CentOS 8 etc.'
---

# OS Base Hardening

## Option A: Use a dsp-appsec custom image

DSP has pre-configured images that are hardened according to CIS benchmarks. You can start an instance based on an image using `gcloud` or the GCP console, using the deployment manager, or using the GCP console. 

**Note**: You need to request image reader permissions from dsp-appsec before gaining access to these images.

#### 1. gcloud command

```text
gcloud compute instances create [INSTANCE_NAME] \
    --image [IMAGE] \
    --image-project dsp-appsec
```

#### 2. Deployment Manager

You can also use Google's deployment manager to manage the instance for you. Use the configuration file  `example.yaml` template below to specify the properties of your instance.

N**ote**: You may need to change zone, network, or machine type properties for your project.

```yaml
resources:
- type: compute.v1.instance
  name: [INSTANCE NAME]
  properties:
    zone: us-central1-f
    machineType: https://www.googleapis.com/compute/v1/projects/[YOUR-PROJECT]/zones/us-central1-f/machineTypes/f1-micro
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: https://www.googleapis.com/compute/v1/projects/dsp-appsec/global/images/[CIS-IMAGE]
    networkInterfaces:
    - network: https://www.googleapis.com/compute/v1/projects/[YOUR-PROJECT]/global/networks/default
      accessConfigs:
      - name: External NAT
        type: ONE_TO_ONE_NAT
```

You can then deploy the instance using the command

```text
gcloud deployment-manager deployments create [DEPLOYMENT-NAME] --config example.yaml
```

#### 3. Console

You can click on the instance in the GCP console and click the "Create Instance" button at the top of the page.

![You can create a hardened instance from a dsp-appsec image.](../.gitbook/assets/screen-shot-2020-03-23-at-8.03.04-pm.png)

You can then go to custom images and select `dsp-appsec` as your project before choosing an image.

![Choosing a custom CIS hardened image.](../.gitbook/assets/screen-shot-2020-04-15-at-4.34.50-pm.png)

dsp-appsec currently has the following images:

* `dsp-appsec-cis-debian9`

## Option B: Use dsp-appsec's ansible playbook for CIS hardening

To run CIS hardening via ansible, clone this repo and call the script. The script will automatically install all the requirements and run the playbook in a virtual environment.

Make sure to replace the `[OS]` below with your system.

Currently, supported systems include:

* `debian9`

```text
git clone https://github.com/broadinstitute/dsp-appsec-base-image-hardening.git

dsp-appsec-base-image-hardening/[OS]/harden-images.sh
```

Click [here](https://github.com/broadinstitute/dsp-appsec-base-image-hardening) for the Github repo.

You can also use dsp-appsec ansible roles in your custom ansible playbook:

* [Debian 9](https://github.com/broadinstitute/dsp-appsec-debian9-hardening-role)

