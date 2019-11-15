# Security 201

This set of security guidelines is language/technology agnostic and it serves as a general secure coding practice. Implementation of these practices aims to help prevent most of the common software vulnerabilities and can be integrated into the software development lifecycle.

{% tabs %}
{% tab title="General Secure Coding Practices" %}

**General Secure Coding Practices**

1. **Verify Code**
   * Use tested and approved managed code rather than creating new unmanaged code for common tasks
   * Use checksums or hashes to verify the integrity of interpreted code, libraries, executables, and configuration files
   * Review all secondary applications, third party code and libraries to determine business necessity and validate safe functionality, as these can introduce new vulnerabilities
2. **Implement Least Privilege**
   * In cases where the application must run with elevated privileges, raise privileges as late as possible, and drop them as soon as possible
   * Restrict users from generating new code or altering existing code
   * Utilize task specific built-in APIs to conduct operating system tasks. Do not allow the application to issue commands directly to the Operating System, especially through the use of application initiated command shells
3. **Be Aware of Low Level Errors**
   * Do not pass user supplied data to any dynamic execution function
   * Avoid calculation errors by understanding your programming language's underlying representation and how it interacts with numeric calculation. Pay close attention to byte size discrepancies, precision, signed/unsigned distinctions, truncation, conversion and casting between types, "not-a-number" calculations, and how your language handles numbers that are too large or too small for its underlying representation
   * Utilize locking to prevent multiple simultaneous requests or use a synchronization mechanism to prevent race conditions
   * Protect shared variables and resources from inappropriate concurrent access

{% endtab %}
{% tab title="Input Validation" %}

**Input Validation**

1. **Processing Data**
   * Specify proper character sets, such as UTF-8, for all sources of input
   * Verify that header values in both requests and responses contain only ASCII characters
   * Encode data to a common character set before validating \(Canonicalize\)
   * Determine if the system supports UTF-8 extended character sets and if so, validate after UTF-8 decoding is completed
2. **Where to Validate**
   * Identify all data sources and classify them into trusted and untrusted. Validate all data from untrusted sources \(e.g., Databases, file streams, etc.\)
   * Conduct all data validation on a trusted system \(e.g., The server\)
   * There should be a centralized input validation routine for the application
3. **When to Validate**
   * Validate all client provided data before processing, including all parameters, URLs and HTTP header content \(e.g. Cookie names and values\). Be sure to include automated post backs from JavaScript, Flash or other embedded code
   * Validate data from redirects \(An attacker may submit malicious content directly to the target of the redirect, thus circumventing application logic and any validation performed before the redirect\)
4. **What to Validate**
   * Validate for expected data types
   * Validate data range
   * Validate data length
   * Validate all input against a "white" list of allowed characters, whenever possible
   * If any potentially hazardous characters must be allowed as input, be sure that you implement additional controls like output encoding, secure task specific APIs and accounting for the utilization of that data throughout the application. Examples of common hazardous characters include: `&lt; &gt; " ' % \( \) & + ' "`

{% hint style="danger" %}
All validation failures should result in input rejection.
{% endhint %}

{% endtab %}
{% tab title="Output Encoding" %}

**Output Encoding**

1. **Output Encoding Process**
   * Conduct all encoding on a trusted system \(e.g., The server\)
   * Utilize a standard, tested routine for each type of outbound encoding
2. **Encode Data**
   * Contextually output encode all data returned to the client that originated outside the application's trust boundary. HTML entity encoding is one example, but does not work in all cases
   * Encode all characters unless they are known to be safe for the intended interpreter
3. **Sanitize Output**
   * Contextually sanitize all output of un-trusted data to queries for SQL, XML, and LDAP
   * Sanitize all output of un-trusted data to operating system commands

{% endtab %}
{% endtabs %}
