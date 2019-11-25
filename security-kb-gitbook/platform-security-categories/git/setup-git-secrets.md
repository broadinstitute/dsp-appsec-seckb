---
description: As a client side-protection
---

# Setup Git-Secrets

## Installing git-secrets

To prevent any secrets that we might accidentally commit to the GitHub repository, we may want to use the git-secrets developed by the _awslabs_ for our repository to keep safe during development.

The following snippet downloads, installs, and configures git-secrets for repositories initiated or cloned _in the future_.

```text
git clone https://github.com/awslabs/git-secrets.git
(cd git-secrets && sudo make install)
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets
git secrets --add --global 'BEGINPRIVATEKEY.*ENDPRIVATEKEY' # google private key pattern
git config --global init.templateDir ~/.git-templates/git-secrets
```

Now enable git-secrets for each _current_ repository with

```text
(cd path/to/my/repo && git secrets --install)
```

**GCP Example**

```text
{
  "type": "service_account",
  "project_id": "my_gcp_account_id",
  "private_key_id": "333d1d68bef68da9ec765f03c5d9bb3457ab92af",
  "private_key": "-----BEGINPRIVATEKEY-----\nb3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAACFwAAAAdz\nNhAAAAAwEAAQAAAgEAtKqj5MX24mM+TaqUdK2h8tMDzOal/ScR9x4P7fHo77urCM\nhMAi07122VBmD9JB5BOX3Wo6xhaB3t9aKnTSShP736NXS8n7bQpq8deyn7UwCuwl\nOVBYSyb6NpwdsIVJ7/nPFz9jKPpPepMd5StJmr8V5rJTP9xFLFewcudyDNk32gv6\njWalhBVloppiKAExq+utChjkR3w4UvAlzmWOlhH/Gyqk1Dc4aKwm9yZAF+kJPtzQ\nCQyJogDbiGtmFwZVp/Bo+FM8qV3hEk7VKqXL91zhQaZ1YldNY31IoGdolj7tUg1I\nOMWGaZYzdiUGYHX6+ZyN//ndoCMNM2SBfHSp1pFi01H7SmyXsiDLSOQFjp9TBDeP\nMwPqUNKJ9+zevXLE2Qk4LxGW/M/Nbiu/OocdkPY8me7DzkgCiUYeoNNon7533THY\nGeH7XgZ70mJUTeakAEeEUa/0Jicp1lW7FFUutRYCRnzXFo2zpm3G2f3RXCwozeuw\n753YbRbU5F+PK7ZVDlXH2sUr4A1yIXCdnf6ubcsvp9h+slUv+Uae/sPrir1RI2Js\nBzcsoZ5FHp6FrmqyueRUbh/0nwLCOe+eZP4aJ9mNDG8nAtTDH2MhO8BrUWtwD9pJ\ncAAAdwShe7oEoXu6AAAAAHc3NoLXJzYQAAAgEAtKqj5MX24mM+TaqUdK2h8tMDzO\n9x4P7fHo77urCMBDh3uPhMAi07122VBmD9JB5BOX3Wo6xhaB3t9aKnTSShP736NX\npq8deyn7UwCuwl+4w5GNOVBYSyb6NpwdsIVJ7/nPFz9jKPpPepMd5StJmr8V5rJT\newcudyDNk32gv6/T7gaajWalhBVloppiKAExq+utChjkR3w4UvAlzmWOlhH/Gyqk\nwm9yZAF+kJPtzQjxVGFlCQyJogDbiGtmFwZVp/Bo+FM8qV3hEk7VKqXL91zhQaZ1\n3G2f3RXCwozeuwNaYh5c753YbRbU5F+PK7ZVDlXH2sUr4A1yIXCdnf6ubcsvp9h+\nae/sPrir1RI2Jsci97e0BzcsoZ5FHp6FrmqyueRUbh/0nwLCOe+eZP4aJ9mNDG8n\nMhO8BrUWtwD9pJDWmGZxcAAAADAQABAAACABXyOJB8v73GYnYax4fY47hUi7yjM/\ncabs4OfmOyOH/2wAxXFRyalA9aP2UT+QwfJLswHxeow/ha0mIpTPtg/Ll6gV9m+9\nJAGnGuF9Tr1L1WzkTGxu5xrR9EkX879SoaWmCdMAHzKGHYt9PX9uH7XNioKInPY/\nDVfpQy+sbg9681qRsMqGcoq18q+q40uKwZbpvQ5h8bEBVPI2O9Fzort2GjAZoQYq\nu5CMYex8G8HxWSdv4U8VF873HbPXoAIiAduxp36q1c6ZGdMYgmp402sL/Ez2RIIa\ndsGFdP85IpDNxe0EbtZqoCZJWZzHJjWXJfVabNrwrBmLpzc10VaiI4JBVj8zwOp7\nptZrhhAjLTt5kkWs00gHLLxOsC6Ni3Ni4BuvPFE8rs0svt1BONEmV1zeFHJWNKxE\nljZWFjY291bnQuY29tAQIDBAU=\n-----ENDPRIVATEKEY-----",
  "client_email": "my_gcp_email@my_gcp_account_id.iam.gserviceaccount.com",
  "client_id": "300698269862192074801",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my_gcp_email@my_gcp_account_id.iam.gserviceaccount.com"
}
```

**AWS Example**

```text
x ="AKIAABCDEFGHIJKLMNOP","H/A604MMvmQjLuZw/xxxxxxxxxxxxxxxxxxxxxxx"
```

## Uninstalling git-secrets

```text
#!/usr/bin/env bash
# Recursively remove references to "git-secrets" from webhooks in all repositories

find . -regex '.*/\.git/hooks/commit-msg' -exec sed -i '' -e 's/git secrets --commit_msg_hook -- "$@"//' {} \;
find . -regex '.*/\.git/hooks/pre-commit' -exec sed -i '' -e 's/git secrets --pre_commit_hook -- "$@"//' {} \;
find . -regex '.*/\.git/hooks/prepare-commit-msg' -exec sed -i '' -e 's/git secrets --prepare_commit_msg_hook -- "$@"//' {} \;
```

