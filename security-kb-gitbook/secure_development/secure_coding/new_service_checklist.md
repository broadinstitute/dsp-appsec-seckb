# New Service Checklist

-   [Your microservice and Github](#your-microservice-and-github)
-   [Scalability](#scalability)
-   [Logging](#logging)
-   [Instrumentation](#instrumentation)
-   [Deployment](#deployment)
-   [Encryption](#encryption)
-   [Authentication](#authentication)
-   [Authorization](#authorization)
-   [Compliance](#compliance)
-   [Code Scans](#code-scans)
-   [Other Security Considerations](#other-security-considerations)

So you want to make a new service? Great! A few things to get started:

-   Make sure you create an initial design document, a template can be
    found
    [here](https://docs.google.com/document/d/1DXvkL8NcmIDMAwN1_tB0RgQO6XJr0jf6xKiRXf2I3nQ/edit#heading=h.m9sgzsze7pd7)
-   Make sure to go through all items in the following questionnaire and
    have all the necessary documentation before meeting with
    security/devops
-   Make sure to setup a security/devops architecture review session
    with security and devops
-   Make sure

Please make sure you have the following things in your code:

Your microservice and Github
============================

-   Do you have a /status endpoint?  
    -   Does it monitor real things like DB connections and other downstream dependencies?  
        -   **In Firecloud**:  
            -   Deploying artifact:  
                -   Your code can be compiled into a Docker. That means
                    having a Dockerfile in your root. OR
                -   Your code can be run in Google App Engine or Google
                    Cloud Functions (serverless)

            -   Any conf files that need to be used by the Docker at runtime should be in firecloud-develop repo.  
                -   No secrets in these files! Use Vault!
                -   Use Git-secrets to doublecheck!
                -   Docker-compose file should be all set!

            -   Put your Secrets in Vault
            -   Make sure your application can run in [FIAB – Firecloud-in-a-Box](https://broadinstitute.atlassian.net/wiki/plugins/servlet/mobile?contentId=229212218#content/view/114755655)  
                -   And is in the fiab branch in Github

            -   You have defined your necessary cloud resources and your Devops team knows (ie CloudSQL databases, bigquery tables, etc).  
                -   This is so security and permissions and deployment
                    can be properly set

        -   **Independent of FC:**  
            -   [Independent Deployment
                Services](https://broadinstitute.atlassian.net/wiki/plugins/servlet/mobile?contentId=229212218#content/view/114755655)
                this is in progress so please consult a devops to see
                where we are on this.
            -   Deploying artifact - you need one  
                -   Needs to deploy to GAE
                -   OR be Dockerized with Dockerfile in Root

            -   Confs need to be considered and should be templatized so we can inject secrets at deploytime  
                -   We prefer consul but will work with any template
                    language (jinja, etc)
                -   No secrets and few hardcodes!

            -   If not using Docker/Kubernetes, include scripts in a /deploy folder  
                -   Should also be templatized

            -   Use git-secrets in your repo
            -   You have defined your necessary cloud resources and your Devops team knows (ie CloudSQL databases, bigquery tables, etc).  
                -   This is so security and permissions and deployment
                    can be properly set

            -   What kind of Test environment does it need? It's own FC?
                No FC? Make sure you've talked to Devops about how you
                intend to test against other projects so that can be
                wrapped.

Scalability
===========

-   Multiple instances of your code can be run at one time without conflicts.  
    -   ie you can just keep slapping on instances of your code for
        scaling (horizontal)

-   Does your code need a shared piece of infrastructure to help in
    scaling, like a Database or a Cache layer? Make sure your Devops
    team knows.
-   Make sure you're set up with an Autoscale group and/or a
    Load-Balancer. Talk to your Devops team.

Logging
=======

-   Does your code log out?  
    -   Configurable to log to File and/or STDOUT.

-   Does it have multiple, configurable log-levels (debug, info, warn,
    error)?
-   Does your logging engine support
    [Sentry?](https://docs.sentry.io/quickstart/)
-   Are there any Alerts that need to be set up on your logs?
-   Make sure your devops person knows if you're logging to STDOUT or
    Logs so they can set up appropriate offsite logging?
-   Is the logging good enough? We should be able to know WHO did WHAT
    to WHAT OBJECT and WHEN?

Instrumentation
===============

-   Is your code instrumented with StatsD?
-   Should it be?
-   Does it go out to Graphite?

Deployment
==========

-   Do you have a scripted solution for CI and CD?  
    -   Jenkins
    -   Circle  
        -   See devops about Secrets. There are many ways to
            accidentially expose secrets during deploys with this
            service.

    -   Travis  
        -   See devops about Secrets. There are many ways to
            accidentially expose secrets during deploys with this
            service.

    -   Other

-   Please make sure your devops person knows and a Jenkins job is all
    set.
-   Can you deploy independently of the rest of Firecloud? Can it deploy
    in FIAB if required?

Encryption
==========

-   Are you using the Apache Proxy for the front-end to your application
    to terminate Encryption? You should.
-   Do you need a certificate for a
    non-\*.dsde-&lt;ENV&gt;.broadinstitute.org URL? Ask your Devops
    team.
-   Are you using persistent storage anywhere (other than a SQL database)? Ask your Devops team about encrypting your storage.  
    -   Is that storage backed-up somehow?

Authentication
==============

-   Is your service authenticated?  
    -   You can use our Apache Proxy

-   Is it service-to-service or "users" or both?
-   How are users or applications acquiring credentials?  
    -   For instance, if a shared secret, are we putting it in vault or
        sending it via email (put it in Vault is the right answer).

-   What scopes do you need? Will this need to change at any time?
-   What Redirect URLs will you need? Will this need to change at any
    time?

Authorization
=============

-   How does your service enforce Authorization?  
    -   How does it revoke authorization?

-   Does it log access attempts?

Compliance
==========

-   If this is an application in our Workbench, have you altered the diagram in the SSP?  
    -   If you don't know what this means, talk to Bernick or Albano.

-   If this is an application in Workbench, have you built a "concept of
    operations" document?

Code Scans
==========

-   ToDo

Other Security Considerations
=============================

-   ToDo
