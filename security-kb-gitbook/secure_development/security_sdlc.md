# Secure SDLC

Before starting a secure code review, make sure you understand the approaches to mechanisms like authentication and data validation. Talk to developers if necessary. Gain an understanding of what the code as a whole is doing and then focus the review on important areas, such as functions that handle user input or interactions with a database.

Assume that all input is malicious and provide a centralized filtering mechanism. In the absence of a single centralized filtering mechanism, provide enough comment in code to enable the same filtering to apply in all other environments accepting the same kind of input.

* Any sensitive resource access should check the logged in user's

  ownership of the resource and that the user is authorized to perform

  an action

* Any upload feature should sanitize the filename provided by the user
* Do not pass user supplied data to any dynamic execution function
* Validate all client provided data before processing, including all

  parameters, URLs and HTTP header content

* Verify that header values in both requests and responses contain

  only ASCII characters

* Validate data from redirects \(An attacker may submit malicious

  content directly to the target of the redirect, thus circumventing

  application logic and any validation performed before the redirect\)

* Sanitize all user inputs or any input parameters exposed to user to

  prevent injection attacks

* Do not hand code or build JSON by string concatenation ever, no

  matter how small the object is, instead use your language defined

  libraries or framework

* Authorization must always be checked on the server. Hiding user

  interface components is fine for user experience, but not an

  adequate security measure

* Deny by default. Positive validation is safer and less error prone

  than negative validation

* Code should authorize against specific resources such as files,

  profiles, or REST endpoints

