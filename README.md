# packer-rhel9

This repository contains a Packer template for building Red Hat 9.x vSphere Templates.

![latest build](https://github.com/dewab/packer-rhel9/actions/workflows/build_test_promote.yml/badge.svg)

## Prerequisites

- Packer (for building)
- Terraform (for build testing)
- VMware vSphere
- Red Hat 9.x ISO (or URL to ISO)

## Building

Recommended to use a local .envrc for setting environment variables for local testing.
Use HashiCorp Vault and Action Variables for CI/CD builds.

### Local Testing

```shell
source .envrc
packer init .
packer validate .
packer build -force .
```

### Variables (local, for testing)

```shell
export PKR_VAR_vsphere_server="<vcenter FQDN/hostname>"
export PKR_VAR_vsphere_user="<vsphere username>"
export PKR_VAR_vsphere_password="<vsphere password>"
export PKR_VAR_vsphere_cluster="<vsphere cluster name>"
export PKR_VAR_vsphere_datacenter="<vsphere datacenter name>"
export PKR_VAR_vsphere_datastore="<vsphere datastore name>"
export PKR_VAR_vsphere_network="<vsphere network PogrGroup>"
export PKR_VAR_vsphere_folder="<vSphere templates folder>"
export PKR_VAR_guest_username="<local username / admin username>"
export PKR_VAR_guest_password="<password>"
export PKR_VAR_guest_redhat_user="<RedHat RHN User Name>"
export PKR_VAR_guest_redhat_password="<RedHat RHN Password/Token>"
export HCP_CLIENT_ID="<client id>"
export HCP_CLIENT_SECRET="<client secret>"
export HCP_PROJECT_ID="<project id>"
export HCP_ORGANIZATION_ID="<org id>"
```

### Variables (CI/CD)

Variables will (mostly) be retrieved from HashiCorp Vault and injected into the environment at runtime.  Variables below are required from elsewhere.

```shell

#### Environment Variables

```text
VAULT_ADDR
VAULT_TOKEN
VAULT_CACERT
VSPHERE_CLUSTER
VSPHERE_DATACENTER
VSPHERE_DATASTORE
VSPHERE_NETWORK
VSPHERE_FOLDER
```

#### Secrets

Secrets are stored in HashiCorp Vault and are injected into the environment at runtime.
