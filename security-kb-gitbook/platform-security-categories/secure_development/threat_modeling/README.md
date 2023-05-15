---
description: DSP Appsec Threat modeling methodology
---

# Threat Modeling

## Introduction

Threat modeling is an approach for analyzing the security of an application. It is a structured approach that enables you to identify, quantify, and address the security risks associated with an application.

{% hint style="info" %}
**Threat Modeling Basics**

* **What?**
  * A repeatable process to find and address all threats to your product
* **Why?**
  * Because attackers think differently
  * Find problems when there’s time to fix them
  * Security Development Lifecycle (SDL) requirement
  * Deliver more secure products
* **When?**
  * The earlier you start, the more time to plan and fix
  * Worst case is for when you’re trying to ship: Find problems, make ugly scope and schedule choices, revisit those features soon
{% endhint %}

## Scope

While doing threat modeling/secure architecture review we can primarily focus on the following areas:

* [ ] Application Architecture Documents
* [ ] Deployment and Infrastructure Considerations
* [ ] Input Validation
* [ ] Authentication
* [ ] Authorization
* [ ] Configuration Management
* [ ] Session Management
* [ ] Cryptography (if applicable - hopefully not applicable 😅)
* [ ] Parameter Manipulation
* [ ] Exception Management
* [ ] Auditing & Logging
* [ ] Application Framework and Libraries

## Threat Modeling Considerations

| Subject                          | Considerations                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Authentication/Authorization** | <p>&#x3C;b>&#x3C;/b></p><ul><li>How do users and other actors in the system, including clients and servers, authenticate each other so that there is a guarantee against impersonation?</li><li>Do all operations in the system require authorization, and are these given to only the level necessary, and no more (for example a user accessing a database has limited access to only those tables and columns they really need access to)?</li></ul>                                                                                                                                                                                                                                                                                                                                                                                |
| **Access Control**               | <p>&#x3C;b>&#x3C;/b></p><ul><li>Is access granted in a role-based fashion? Are all access decisions relevant at the time access is performed? (token/permissions updated with state-changing actions; token/permissions checked before access is granted).</li><li>Are all objects in the system subject to proper access control with the appropriate mechanisms (files, web pages, resources, operations on resources, etc.)?</li><li>Is access to sensitive data and secrets limited to only those who need it?</li></ul>                                                                                                                                                                                                                                                                                                           |
| **Trust Boundaries**             | <p>&#x3C;b>&#x3C;/b></p><ul><li>Can you clearly identify where the levels of trust change in your model?</li><li>Can you map those to access control, authentication and authorization?</li></ul>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| **Auditing**                     | <ul><li>Are security-relevant operations being logged?</li><li>Are logging best practices being followed: no PII, secrets are logged. Logging to a central location, compatible with industry standards such as SIEM, RFC 5424 and 5427, and OWASP.</li></ul>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| **Cryptography (if applicable)** | <p>&#x3C;b>&#x3C;/b></p><ul><li>Are keys of a sufficient length and algorithms in use known to be good (no collisions, no easy brute-forcing, etc.)?</li><li>Are all implementations of crypto well-tested and up to their latest known secure patch, and is there no use of cryptography developed in house?</li><li>Can cryptography be easily configured/updated to adapt to changes?</li></ul>                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **Secret Management**            | <p>&#x3C;b>&#x3C;/b></p><ul><li><p>What are the tokens, keys, credentials, secrets, etc. in your system?</p><ul><li>How are they protected?</li><li>Are any secrets distributed with the application (hard-coded)?</li></ul></li><li>Are well-established and tested systems being used to store secrets?</li><li>Are any secrets (API or SSH keys, client secrets, AWS access keys, SSL private keys, chat client tokens, etc.) stored unencrypted in repositories, document shares, container images, local storage in browser, etc.?</li><li>Are secrets passed in through environmental variables as part of any build/deploy procedures?</li><li>Are secrets and sensitive data scrubbed from memory as soon as they are used, or is there a possibility that they would be logged?</li><li>Can keys be easily rotated?</li></ul> |
| **Injection**                    | Are all inputs coming from outside the system being inspected for malformed or dangerous input? (this is especially relevant to systems accepting data files, input that gets displayed as part of web pages, binaries, scripts or input that gets directly incorporated into SQL queries, and to systems that embed interpreters of, among others, Lua, JavaScript, LISP, etc.). Are you using context-aware templating systems/frameworks? E.g. React                                                                                                                                                                                                                                                                                                                                                                                |
| **Resiliency/DOS**               | <p>&#x3C;b>&#x3C;/b></p><ul><li>Does the system depend on any single point of failure that could suffer a denial of service attack?</li><li>If the system is distributed among many service nodes, is it possible to isolate a part of them, degrading the service but not interrupting it, in case of a localized security breach?</li><li>Does the system provide feedback controls (monitoring) to allow it to call for help as a denial of service or system probing takes place?</li></ul>                                                                                                                                                                                                                                                                                                                                        |
| **Third Party Components**       | <p>&#x3C;b>&#x3C;/b></p><ul><li><p>Are all dependencies (both direct and transitive):</p><ul><li>Updated to mitigate all known vulnerabilities?</li><li>Obtained from trusted sources (e.g. published by a well known company or developer that promptly addresses security issues) and verified as originating from the same trusted source?</li><li>Code-signing for libraries and installers is highly recommended - has code-signing been implemented?</li></ul></li><li>Does the installer validate checksums for components downloaded from external sources?</li><li>Is there an embedded browser (embedded Chromium, Electron framework, and/or Gecko)? If so, please see the "API" section under "Performing Threat Model".</li></ul>                                                                                         |

## Threat Modeling Tooling

Threat modeling can be assisted by tooling such as PyTM, in which Python code is used to model the system, and the PyTM library automatically generates diagrams and lists of dataflows and possible threats ready for human consideration. See the [dsp-appsec-terra-threat-models](https://github.com/broadinstitute/dsp-appsec-terra-threat-models) repo. Also see [reference documentation](threat\_documentation.md) for the threats generated by PyT.

## Threat Modeling Output

After the process of analyzing the assets, data flows, threats, and mitigations is complete, the result is a document

The output, a threat model, is a document (MS Word, HTML, etc.) that should be appropriately stored so that only stakeholders have access. The final Threat Model document must have a brief description of your product, Data Flow Diagram(s) and the threats identified (following the structure described later in this Handbook). A complete threat model will include the following:

1. General and detailed Data Flow Diagrams (L0 and L1 DFDs)
2. Network traffic requirements (ports in use, requirements from firewalls, etc.)
3. Questions in the "Performing Threat Model" section have been answered.
4. Findings the development team identified with ticket links (format specified below in the section, "Documenting Findings").
5. In the Threat Model document, list:
6. Location and nature of sensitive data – the “crown jewels” (data, assets, functionality) that we want to protect.
7. Uses of cryptography.
8. The threat model Curator and other stakeholders involved.
