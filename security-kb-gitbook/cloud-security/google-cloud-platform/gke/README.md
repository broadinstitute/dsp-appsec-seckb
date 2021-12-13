# Secure GKE

1. Ensure **Stackdriver Logging** enabled on GKE Clusters - [https://cloud.google.com/monitoring/kubernetes-engine/legacy-stackdriver/logging](https://cloud.google.com/monitoring/kubernetes-engine/legacy-stackdriver/logging)
2. Ensure legacy authorization is disabled.&#x20;
3. **“Master authorized networks”** should be enabled and should use the Networks from the Securing the Network section.  _\*\*_[https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks)       &#x20;

The most up-to-date list of Broad IP ranges can be found at [gs://broad-institute-networking/internal\_networks.json](https://console.cloud.google.com/storage/browser/\_details/broad-institute-networking/internal\_networks.json)

```
   (69.173.127.0/25)
   (69.173.124.0/23)
   (69.173.126.0/24)
   (69.173.127.230/31)
   (69.173.64.0/19)
   (69.173.127.224/30)
   (69.173.127.192/27)
   (69.173.120.0/22)
   (69.173.127.228/32)
   (69.173.127.232/29)
   (69.173.127.128/26)
   (69.173.96.0/20)
   (69.173.127.240/28)
   (69.173.112.0/21)
```

1. Ensure the **Kubernetes Web Dashboard** is disabled.
2. Ensure **Basic Auth** is disabled.
3. Ensure **automatic node repair and/or upgrades** is enabled [https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-upgrades](https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-upgrades)
4. Ensure **Network and PodSecurity policies** are enabled for a cluster. [https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies](https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies)
5. Create cluster with limited service account access scopes.
6. Use a private cluster if you can - [https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)

Please see Infosec about getting on the Alpha for Kubernetes Threat Detection.

{% hint style="info" %}
_**Note: After March 1st, 2020 GKE Threat Detection will be enabled for all projects under broadinstitute gcp org.**_
{% endhint %}
