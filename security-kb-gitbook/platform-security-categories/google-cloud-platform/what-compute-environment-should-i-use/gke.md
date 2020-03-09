# GKE

- Ensure Stackdriver Logging enabled on GKE Clusters - https://cloud.google.com/monitoring/kubernetes-engine/legacy-stackdriver/logging
- Ensure legacy authorization is disabled.
** Critical! **
- “Master authorized networks” Should be enabled and should use the Networks from the GCE section.
** This one is Critical! ** 
* https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks
* (69.173.127.0/25)
* (69.173.124.0/23)
* (69.173.126.0/24)
* (69.173.127.230/31)
* (69.173.64.0/19)
* (69.173.127.224/30)
* (69.173.127.192/27)
* (69.173.120.0/22)
* (69.173.127.228/32)
* (69.173.127.232/29)
* (69.173.127.128/26)
* (69.173.96.0/20)
* (69.173.127.240/28)
* (69.173.112.0/21)
- Ensure the Kubernetes Web Dashboard is disabled.
- Ensure Basic Auth is disabled
- Ensure automatic node repair and/or upgrades is enabled https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-upgrades
- Ensure Network and PodSecurity policies are enabled for a cluster. https://cloud.google.com/kubernetes-engine/docs/how-to/pod-security-policies
- Create cluster with limited service account access scopes.
- Use a private cluster if you can - https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters
- Please see Infosec about getting on the Alpha for Kubernetes Threat Detection
_Note: After March 1st, 2020 GKE Threat Detection will be enabled for all projects under broadinstitute gcp org._
