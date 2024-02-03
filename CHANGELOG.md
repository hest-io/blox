## CHANGELOG

> Below are significant or impactful changes present in the listed version(s)


### v2.0.0

- Cleanup of Terraform versions. Added OpenTofu. Removal of landscape tool
- fix: CI sync job
- Update .gitlab-ci.yml file
- Fix python path
- WORX-296
- fix: tf 0.11 support for tf autver region detection
- Tools update
- fix: terraform-state-doc
- Sync with GitHub
- Polishing terraform-state-doc description
- terraform-state-doc
- fix: tf autover
- feat: CI slack notifications
- fix: tf plan whithout AWS creds
- feat: tf use
- feat: tfver
- WORX-200
- [TF autover] add support for AWS region
- Updated driftctl version to include fix for S3 Buckets https://github.com/snyk/driftctl/pull/1591
- update/tfversion
- Docs/update
- Docs/update
- Updated several tools to latest version
- Updated infracost version
- Merge branch 'develop' into 'master'
- Added subcommand for auto-detection of TF version from statefile
- Added initial starship config
- Updated repo docs

### vv1.9

- Updated config for Starship usage
- Updated tool versions for Terraform, Infracost and Driftctl
- Corrected upstream source to "latest"
- Moved BLOX to main AWSH upstream
- Correction for Packer installation
- Correction for Packer version variable
- Updated Packer to latest version
- Upgraded TF to v1.1.0
- Corrected command alias
- Updated exec permissions for new tools
- Added more tooling for Terraform
- Swapped to maintained fork of ami-cleaner
- Added driftctl https://driftctl.com/
- Replaced TF 0.11 version with latest 0.11.x containing CVE fix
- Added TF 0.13 and removed older 0.11.3 version. TF 0.13 requires forced upgrade as part of upgrade path to 0.15 and 1.x
- Cleanup of deprecated config entry for tflint
- Updated wrapper to be clear with lint vs validate is being run
- Upgraded TFlint version for recent Terraform version compatibility
- Updated docs, license for repo
- Updated CICD pipeline to align with AWSH. Added infracost tool
- Added new TF versions
- Added 0.11.x version to handle legacy code issues as a result of the revent GPG issue with providers
- Addition of TF 0.12.31 to handle https://discuss.hashicorp.com/t/hcsec-2021-12-codecov-security-event-and-hashicorp-gpg-key-exposure/23512
- Minor fixes and improvements to reflect Python3 based AWSH layer
- Added Gruntwork CLI
- Added CICD config for GitLab
- Replaced amicleaner with recent working version
- Improved handling of multiple TF versions and added switcher command to change default TF version
- Updates to local dev container config
- Replaced broken aws-amicleaner with working fork
- Upgraded of Ansible to 2.8.x for new module support
- Added support for WinRM in Ansible
- Added Terraform 0.12.20 and updated default TF to 0.12.20
- Added support for multiple Python package installation via requirements
- Added Packer and Ansible to Docker image
- Added workaround for another GitLab CICD issue where it executes the ENTRYPOINT once for each stage in a CICD pipeline
- Added potential fix for GitLab CICD failing due to use of $@
- Re-ordered init to ensure default TF version
- README cleanup
- Revision to support working BLOX container
- Added local (for Devs) and user compose files
- Added initial version of additional tools to workspace
