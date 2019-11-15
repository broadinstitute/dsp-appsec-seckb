
# Secure the Network

Disable the default **tcp:22** and default **tcp:3389** firewall rules which allows SSH and RDP access to all VMs on the default network. Also, deploy all your machines on a non-default network that does not include those rules.

See Google Cloud's [Firewall documentation](https://cloud.google.com/vpc/docs/using-firewalls) for reference.

Example: **gcloud compute firewall-rules delete default-allow-ssh default-allow-rdp --project my-project-name**

Optionally, you can also delete the "default" network and create a managed network and subnet. 

1. **Delete the network.**

   a. `gcloud compute networks delete default`

2. **Create a managed network and subnet -- allow only Broad Networks to access.**

  a. Create a network:

    `gcloud compute networks create [NETWORK-NAME]`

      i. You can use any name for your network.

  b. Create a subnet:

    `gcloud compute networks subnets create [SUBNET-NAME] --network=[NETWORK-NAME] --enable-flow-logs --range=10.100.1.0/24`
        * Note, your range might vary depending on what you want.
        * You can use any name for your subnet. We would encourage subnet names to follow the form `[NETWORK-NAME]-subnet`
        * You might want to talk to bits if you want to create an absolutely unique --range.

3. **Create firewall rules.**

    `gcloud --project --account compute firewall-rules create [RULES-NAME] --allow=tcp: --target-tags broad-allow --network=[NETWORK-NAME] --source-ranges=69.173.112.0/21,69.173.127.232/29,69.173.127.128/26,69.173.127.0/25,69.173.127.240/28,69.173.127.224/30,69.173.127.230/31,69.173.120.0/22,69.173.127.228/32,69.173.126.0/24,69.173.96.0/20,69.173.64.0/19,69.173.127.192/27,69.173.124.0/23 --enable-logging`

      i. There is a chance this command is slightly different depending on the exact version of gcloud you have. 

      ii. Rules name can be anything you want. I encourage having the first part as the name of your network. 

      iii. The “tcp:port” can be a comma separated list of tcp ports or a range that you’re opening to specific targets.
        * You can put 0-60000 if you want all ports

      iv. **Anytime you want to open a port, alter this rule, don’t create a new one.**
        * You can totally create a new rule, but be REALLY mindful of it.

      v. **“--target-tag broad-allow” means that any machine with “broad-allow” tag on it will be accessible on all ports on Broad Networks only.**
        * Use other tags when you create firewall rules of your own.

  That above command will enable all Broad users on VPN or at a Broad office to contact all machines in the “managed” network but be blocked to the rest of the world.

Look at the docs for Firewall rules to see more on how to open your machines to the outside world or how to **narrow** to a set of machines \(“targets”\).


