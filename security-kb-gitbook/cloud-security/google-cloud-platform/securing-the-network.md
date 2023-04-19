---
description: >-
  Note: Newly created projects do not have a default network setup. If you want
  to use a GCE, you will need to create your own network.
---

# Securing the Network

## Access your GCE through SSH or RDP

1.  Create a network:

    `gcloud compute networks create [NETWORK-NAME]`
2.  Create a subnet:

    `gcloud compute networks subnets create [SUBNET-NAME] --network=[NETWORK-NAME] --enable-flow-logs --range=10.100.1.0/24`

We recommend using the `[NETWORK-NAME]-subnet` format for your subnet name. You may also want to change the range for your subnet, but please talk to BITs when creating a unique range.

_**Note: You don't need to create any firewall rules as this has been done for you already.**_

3. [Enable OS Login -](https://cloud.google.com/compute/docs/oslogin/set-up-oslogin#enable\_os\_login) This simplifies SSH access management by linking your Linux user account to your Google identity. This does not have to be enabled if you are using RDP
4.  Create your GCE and attached it to the created subnetwork&#x20;

    ```
    gcloud compute instances create VM_NAME \
      --network=NETWORK_NAME \
      --subnet=SUBNET_NAME \
      --zone=ZONE
    ```
5.  [Grant the user account ](https://cloud.google.com/iam/docs/granting-changing-revoking-access#iam-grant-single-role-console)that needs to access the GCE with the following permissions:

    * `Compute Admin`
    * `Compute OS login`(We recommend enabling OS login on the project/VM)
    * `IAP-Secured Tunnel User`

    **Optional**: `Service account user` on the service account running your VM ( Only used if the VM being access is running with a service account - DO NOT to use the default service accounts)

You can then access your machine using either of these options:

1. SSH access
   * In-console ssh (GUI SSH button)
   * In-console cloud shell using the command `gcloud compute ssh --zone [zone] [instance] --project [project_name] --tunnel-through-iap`
   * Local (Your computer’s) terminal without VPN into Broad using the command `gcloud compute ssh --zone [zone] [instance] --project [project_name] --tunnel-through-iap`
   * Local (Your computer’s)  terminal while VPN'ed into Broad using the command `gcloud compute ssh --zone [zone] [instance] --project [project_name]`
2. RDP access - [Review Google's documentation on Tunneling RDP connections](https://cloud.google.com/iap/docs/using-tcp-forwarding#iap-desktop\_1)

## Creating Firewall Rules for any other access

### 1. Create a Firewall Rule

Firewall rules refer to either incoming (ingress) or outgoing (egress) traffic. You can target certain types of traffic based on its protocol, ports, sources, and destinations.

* Be REALLY mindful when creating new rules.
* If you want to alter the range of ports, [update the current rule](https://cloud.google.com/vpc/docs/using-firewalls#updating\_firewall\_rules) rather than create a new one.
* DO NOT USE the `broad-allow` tag when creating a new rule.
* It is recommended to use the network in the rule's name.

```
gcloud compute firewall-rules create NAME \
    [--network NETWORK; default="default"] \
    [--priority PRIORITY;default=1000] \
    [--direction (ingress|egress|in|out); default="ingress"] \
    [--action (deny | allow )] \
    [--target-tags TAG,TAG,...] \
    [--target-service-accounts=IAM Service Account,IAM Service Account,...] \
    [--source-ranges CIDR-RANGE,CIDR-RANGE...] \
    [--source-tags TAG,TAG,...] \
    [--source-service-accounts=IAM Service Account,IAM Service Account,...] \
    [--destination-ranges CIDR-RANGE,CIDR-RANGE...] \
    [--rules (PROTOCOL[:PORT[-PORT]],[PROTOCOL[:PORT[-PORT]],...]] | all ) \
    [--disabled | --no-disabled]
    [--enable-logging | --no-enable-logging]       
```

The following example will enable all Broad users on VPN or at a Broad office to contact all machines in the network on port 6677 but be blocked to the rest of the world.

```
gcloud --project --account compute firewall-rules create [RULES-NAME] \
    --allow=tcp \ # could also use tcp:6677
    --target-tags broad-allow \ 
    --network=[NETWORK-NAME] \
    --source-ranges=69.173.112.0/21,69.173.127.232/29,69.173.127.128/26,69.173.127.0/25,69.173.127.240/28,69.173.127.224/30,69.173.127.230/31,69.173.120.0/22,69.173.127.228/32,69.173.126.0/24,69.173.96.0/20,69.173.64.0/19,69.173.127.192/27,69.173.124.0/23 \
    --enable-logging
```

Look at the [docs for Firewall rules](https://cloud.google.com/vpc/docs/using-firewalls#creating\_firewall\_rules) to see more on how to open your machines to the outside world or how to **narrow** to a set of machines (“targets”).

