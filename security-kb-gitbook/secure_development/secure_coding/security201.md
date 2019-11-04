# Security 201

## Security 201

* [General Secure Coding Practices](security201.md#general-secure-coding-practices)
* [Input Validation](security201.md#input-validation)
* [Output Encoding](security201.md#output-encoding)

This set of security guidelines is language/technology agnostic and it serves as a general secure coding practice. Implementation of these practices aims to help prevent most of the common software vulnerabilities and can be integrated into the software development lifecycle.

## General Secure Coding Practices

* Use tested and approved managed code rather than creating new

  unmanaged code for common tasks

* Utilize task specific built-in APIs to conduct operating system

  tasks. Do not allow the application to issue commands directly to

  the Operating System, especially through the use of application

  initiated command shells

* Use checksums or hashes to verify the integrity of interpreted code,

  libraries, executables, and configuration files

* Utilize locking to prevent multiple simultaneous requests or use a

  synchronization mechanism to prevent race conditions

* Protect shared variables and resources from inappropriate concurrent

  access

* In cases where the application must run with elevated privileges,

  raise privileges as late as possible, and drop them as soon as

  possible

* Avoid calculation errors by understanding your programming

  language's underlying representation and how it interacts with

  numeric calculation. Pay close attention to byte size discrepancies,

  precision, signed/unsigned distinctions, truncation, conversion and

  casting between types, "not-a-number" calculations, and how your

  language handles numbers that are too large or too small for its

  underlying representation

* Do not pass user supplied data to any dynamic execution function
* Restrict users from generating new code or altering existing code
* Review all secondary applications, third party code and libraries to

  determine business necessity and validate safe functionality, as

  these can introduce new vulnerabilities

## Input Validation

* Conduct all data validation on a trusted system \(e.g., The server\)
* Identify all data sources and classify them into trusted and

  untrusted. Validate all data from untrusted sources \(e.g.,

  Databases, file streams, etc.\)

* There should be a centralized input validation routine for the

  application

* Specify proper character sets, such as UTF-8, for all sources of

  input

* Encode data to a common character set before validating

  \(Canonicalize\)

* All validation failures should result in input rejection
* Determine if the system supports UTF-8 extended character sets and

  if so, validate after UTF-8 decoding is completed

* Validate all client provided data before processing, including all

  parameters, URLs and HTTP header content \(e.g. Cookie names and

  values\). Be sure to include automated post backs from JavaScript,

  Flash or other embedded code

* Verify that header values in both requests and responses contain

  only ASCII characters

* Validate data from redirects \(An attacker may submit malicious

  content directly to the target of the redirect, thus circumventing

  application logic and any validation performed before the redirect\)

* Validate for expected data types
* Validate data range
* Validate data length
* Validate all input against a "white" list of allowed characters,

  whenever possible

* If any potentially hazardous characters must be allowed as input, be

  sure that you implement additional controls like output encoding,

  secure task specific APIs and accounting for the utilization of that

  data throughout the application . Examples of common hazardous

  characters include: &lt; &gt; " ' % \( \) & + ' "

## Output Encoding

* Conduct all encoding on a trusted system \(e.g., The server\)
* Utilize a standard, tested routine for each type of outbound

  encoding

* Contextually output encode all data returned to the client that

  originated outside the application's trust boundary. HTML entity

  encoding is one example, but does not work in all cases

* Encode all characters unless they are known to be safe for the

  intended interpreter

* Contextually sanitize all output of un-trusted data to queries for

  SQL, XML, and LDAP

* Sanitize all output of un-trusted data to operating system commands

