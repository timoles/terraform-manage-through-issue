# name: "terraform-comment-deploy"
description: "Allows to create and destroy resources with terraform, all managed through issues."

Hetzner

TODO

## Secret storage

Sensitive values are expected within the GitHub repository secrets

* HCLOUD_TOKEN - Your Hcloud token
* CLOUD_INIT_PASSWORD - Password for basic user which will be created through cloud-init file
* CLOUD_INIT_USERNAME = Username for basic user which will be created through cloud-init file

# Additonal Terraform vars

Non-secret variables: Can be added or removed by removing the from the terraform variable definition `variables.tf` and variables file `variables.tfvars`.

Secret variables: Currently need to be added to the GitHub repository secrets and also passed within the GitHub composite calls als env variables

## Example action in your repository

```yaml
# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the workflow will run
on:
  issue_comment:
    types:
    - created
  issues:
    types:
    - opened

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2

      # Runs a single command using the runners shell
      - name: terraform-manage-on-issue
      # You may pin to the exact commit or the version.
        uses: timoles/terraform-manage-on-issue@main
```

## Periodic Resource Destroy

You can periodically destroy deployed resources by searching for stale issues with the `deployed` label and comment them with `/destroy`.

Please note that the following action can only mark stale issues after 24 hours. Due to this an instance runs for `24h + cron_schedule`.

```yaml
name: Stale repo check and comment destroy

on:
  schedule:
    - cron: '0 */3 * * *' # Run every three hours

jobs:
  stale_issue:
    # Copied from https://github.com/github/docs/blob/6d7b73256f86778cd0e0045d54a6e9acea128ce6/.github/workflows/triage-stale-check.yml
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@cdf15f641adb27a71842045a94023bef6945e3aa
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-issue-message: '/destroy Server will be shut down due to issue inactivity.'
          stale-issue-label: 'stale'
          days-before-issue-stale: 1
          days-before-issue-close: 1
          only-issue-labels: deployed

```
