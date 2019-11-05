# security-kb-gitbook
Gitbook version of sec-kb. See the gitbook [here](https://app.gitbook.com/@dsp-security/s/dsp-appsec/).

### Editing

The Gitbook can be edited directly in the Gitbook web app or via Markdown using Github. 

#### Using the Web App

1. Content can be edited at [https://app.gitbook.com/@dsp-security/s/dsp-appsec/](https://app.gitbook.com/@dsp-security/s/dsp-appsec/).
	* See Gitbook documentation for editing content via the web app at [https://docs.gitbook.com/content-editing](https://docs.gitbook.com/content-editing)
2. After editing, save the draft and ***merge the new content with Github by clicking the "Merge" button in the left-hand sidebar.*** This will update the code in Github.

#### Editing Markdown

1. Gitbook uses basic markdown with additional features specific to Gitbook [https://docs.gitbook.com/content-editing/markdown](https://docs.gitbook.com/content-editing/markdown).
2. Push updates to Github and make a PR with the master branch.
3. After merging to master, Github will automatically sync with Gitbook. This may take a while.

### Adding Images

1. First add the image to the `security-kb-gitbook/.gitbook/assets` folder.
2. Then add the image link to the markdown code using ![A caption for the image][../.gitbook/assets/YOUR-IMAGE-NAME.png]