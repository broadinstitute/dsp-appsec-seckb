# Secure Development

{% tabs %}
{% tab title="SDARQ" %}
**Description:**

Developers should understand as early as possible what security requirements are applicable to a service before they are launching it. To make sure security is involved in a discussion at the design/architecture phase, developers must go through a list of steps to define these security requirements.

**Tools:**

* [SDARQ](https://sdarq.dsp-appsec.broadinstitute.org/newservice)
{% endtab %}

{% tab title="CI/CD security" %}
**Description:**

Are our deployments secure with the right levels of authorization and authentication so that only the "right" people can kick off deployments? 

_Production deployments should not be able to run from "random" PRs without some sort of security process._
{% endtab %}

{% tab title="Secrets Management" %}
**Description:**

Make sure secrets are properly stored and encrypted. Access to secrets is granted on a need-to-know basis. Secrets must be regularly expired and rotated. Robust logs are stored so that access can be audited in the future.

**Tools:**

* Vault
* Secret Manager
* Git Secrets
{% endtab %}
{% endtabs %}

