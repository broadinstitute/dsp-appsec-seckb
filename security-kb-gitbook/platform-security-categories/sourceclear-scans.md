# Sourceclear Scans

Broad has a Github Action that scans your project's third party components each week using the Sourceclear CLI agent. Results our uploaded to Broad's Sourceclear database before being verified by application security engineers, who will contact you with any high risk vulnerabilities and required patches.

The Github Action is located in the [dsp-appsec-sourceclear-github-actions](https://github.com/broadinstitute/dsp-appsec-sourceclear-github-actions) repo. 

### To Add a Repo to the Scans:

1. Clone the repo and make a new branch, named `add-[YOUR-PROJECT]`.
2. Add your project to the list in the `projects.json` file. Project should be in the following format.

```text
{
    "project": "project-name",
    "branch": "branch-to-scan",
    "org": "github-repo-organization",
    "subdir": "/build-file-location",
    "workspace": "workspace"
}
```

* Project name should also be the name of the repo.
* Org should be one of `broadinstitute`, `humancellatlas`, or `databiosphere`.
* Subdir should be the location of the build file \(`requirements.txt`, `pom.xml`, etc.\). The form should be `/[YOUR]/[DIRECTORY]`. Default is the root directory of the repo \(leave `subdir` blank\).
* Workspace should be one of `dsde` or `kdux`.
* Make sure `project.json` is valid JSON.

3. Create a PR in this repository and someone from AppsSec team will approve it. 

4. You can then merge your PR.

#### If Your Project uses Python3...

Add a `srcclr.yml` file to your project directory.

```text
touch srcclr.yaml

echo 'python_path: /usr/bin/python3.7' > srcclr.yml
```

