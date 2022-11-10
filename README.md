# BLOX: Containerized Tools for developing and building on AWS

[![GitHub license](https://img.shields.io/github/license/hest-io/blox.svg?style=flat-square)](https://github.com/hest-io/blox/blob/master/LICENSE)
[![GitHub changelog](https://img.shields.io/badge/documentation-ONLINE-651fff.svg?style=flat-square)](https://worx.hest.io/blox/)
[![Docker Pulls](https://img.shields.io/docker/pulls/hestio/blox.svg)](https://hub.docker.com/r/hestio/blox)

## What is BLOX?

![showcase](docs/media/images/showcase-blox.png)

- Containerized Shell with AWS tools inside
  - [Hestio AWSH](https://worx.hest.io/awsh/)
  - [Terraform](https://www.terraform.io/) (multiple versions)
  - [Packer](https://www.packer.io/)
  - [Infracost](https://github.com/infracost/infracost)
  - [Landscape](https://github.com/coinbase/terraform-landscape)
- Developer workspace for Cloud Engineering
- Integrates with Microsoft VS Code (Local, Remote:Container, Remote:WSL, Remote:SSH)
- Compatible with any Operating System that supports Docker (Windows, Linux, MacOS)


## Docker by default

The preferred method of installing and using BLOX is now a Docker container based version that brings you all that you need to run and use BLOX without disrupting your normal OS package setup.

This should make it easier for you to use the latest version and make it easier to rollback an update if a new version breaks something you relied on


## Get and use BLOX

### Basic Usage

- From your command line pull and run the latest BLOX image

    ```console
    $ docker run -it --rm hestio/blox
    ```

### Use BLOX with persistent identities, workspace and  a specific Terraform version by default

- Create a path to store your identities and configuration files

    ```console
    $ mkdir -p ${HOME}/.awsh ${HOME}/.awsh/identities ${HOME}/workspace
    $ touch ${HOME}/.bashrc_local ${HOME}/.awsh/identities/.netrc
    ```

- Set the PUID and PGID of current user to the container
    ```console
    PUID=$(id -u)
    PGID=$(id -g)
    ```

- Run the BLOX container, passing in your AWSH identities and workspace directory

    ```console
    $ docker run \
        -it \
        --name=hestio_blox \
        --rm \
        --network=host \
        --user ${PUID}:${PGID} \
        -v ${HOME}/.awsh:/home/awsh/.awsh \
        -v ${HOME}/workspace:/home/awsh/workspace \
        -v /tmp:/tmp \
        -v $HOME/.awsh/identities/.netrc:/home/awsh/.netrc \
        -v $HOME/.bashrc_local:/home/awsh/.bashrc_local \
        -e "DEFAULT_TERRAFORM_VERSION=0.15.5" \
        -e "HOME=/home/awsh" \
        -e "PUID=${PUID}" \
        -e "PGID=${PGID}" \
        hestio/blox
    ```

`The below steps are only required the first time you configure the container`

- Configure the starship once logged into the BLOX container
    ```console
    starship init bash > ${HOME}/.bashrc_local
    ```
- Activate the starship by running the following command inside the BLOX container
    ```console
    source .bashrc_local
    ```

### Use BLOX with persistent identities, workspace, proxy config and Active Directory/Kerberos credentials

- Create a path to store your identities

    ```console
    $ mkdir -p ${HOME}/.awsh ${HOME}/.awsh/identities ${HOME}/workspace
    $ touch ${HOME}/.bashrc_local ${HOME}/.awsh/identities/.netrc
    ```

- Set the PUID and PGID of current user to the container
    ```console
    PUID=$(id -u)
    PGID=$(id -g)
    ```

- Run the BLOX container, passing in your AWSH identities and your Kerberos setup and your proxy environment

    ```console
    $ docker run \
        -it \
        --name=hestio_blox \
        --network=host \
        -v ${HOME}/.awsh:/home/awsh/.awsh \
        -v /etc/krb5.conf:/etc/krb5.conf \
        -v /etc/krb5.conf.d/:/etc/krb5.conf.d/ \
        -v ${HOME}:/workspace \
        -v /tmp:/tmp \
        -v $HOME/.awsh/identities/.netrc:/home/awsh/.netrc \
        -v $HOME/.bashrc_local:/home/awsh/.bashrc_local \    
        -e "http_proxy=${http_proxy}" \
        -e "https_proxy=${https_proxy}" \
        -e "no_proxy=${no_proxy}" \
        -e "KRB5CCNAME=${KRB5CCNAME}" \
        hestio/blox
    ```

`The below steps are only required the first time you configure the container`

- Configure the starship once logged into the BLOX container
    ```console
    starship init bash > ${HOME}/.bashrc_local
    ```
- Activate the starship by running the following command inside the BLOX container
    ```console
    source .bashrc_local
    ```

### Use BLOX with persistent identities, workspace, proxy config and use a specific Terraform version by default

- Create a path to store your identities

    ```console
    $ mkdir -p ${HOME}/.awsh ${HOME}/.awsh/identities ${HOME}/workspace
    $ touch ${HOME}/.bashrc_local ${HOME}/.awsh/identities/.netrc
    ```

- Set the PUID and PGID of current user to the container
    ```console
    PUID=$(id -u)
    PGID=$(id -g)
    ```

- Run the BLOX container, passing in your AWSH identities and your Kerberos setup and your proxy environment

    ```console
    $ docker run \
        -it \
        --name=hestio_blox \
        --network=host \
        -v ${HOME}/.awsh:/home/blox/.awsh \
        -v /etc/krb5.conf:/etc/krb5.conf \
        -v /etc/krb5.conf.d/:/etc/krb5.conf.d/ \
        -v ${HOME}:/workspace \
        -v /tmp:/tmp \
        -v $HOME/.awsh/identities/.netrc:/home/awsh/.netrc \
        -v $HOME/.bashrc_local:/home/awsh/.bashrc_local \
        -e "http_proxy=${http_proxy}" \
        -e "https_proxy=${https_proxy}" \
        -e "no_proxy=${no_proxy}" \
        -e "KRB5CCNAME=${KRB5CCNAME}" \
        -e "DEFAULT_TERRAFORM_VERSION=0.15.5" \
        hestio/blox
    ```

`The below steps are only required the first time you configure the container`

- Configure the starship once logged into the BLOX container
    ```console
    starship init bash > ${HOME}/.bashrc_local
    ```
- Activate the starship by running the following command inside the BLOX container
    ```console
    source .bashrc_local
    ```

### Create a wrapper script to allow BLOX to be used as a Shell
The following wrapper script is an example of **Use BLOX with persistent identities, workspace and a specific Terraform version by default**

- Create the wrapper script `/usr/local/bin/blox`

    ```bash
    #!/bin/bash

    PUID=$(id -u)
    PGID=$(id -g)

    [ -d ${HOME}/.awsh ] || mkdir -p ${HOME}/.awsh ${HOME}/.awsh/identities ${HOME}/workspace
    touch ${HOME}/.bashrc_local ${HOME}/.awsh/identities/.netrc

    docker run \
        -it \
        --name=hestio_blox \
        --rm \
        --network=host \
        --user ${PUID}:${PGID} \
        -v ${HOME}/.awsh:/home/awsh/.awsh \
        -v ${HOME}/workspace:/home/awsh/workspace \
        -v /tmp:/tmp \
        -v $HOME/.awsh/identities/.netrc:/home/awsh/.netrc \
        -v $HOME/.bashrc_local:/home/awsh/.bashrc_local \
        -e "DEFAULT_TERRAFORM_VERSION=0.15.5" \
        -e "HOME=/home/awsh" \
        -e "PUID=${PUID}" \
        -e "PGID=${PGID}" \
        hestio/blox
    ```

- Make the wrapper executable

    ```console
    sudo chmod a+x /usr/local/bin/blox
    ```

- Start the wrapper script normally

    ```console
    blox
    ```

`The below steps are only required the first time you configure the container`

- Configure the starship once logged into the BLOX container
    ```console
    starship init bash > ${HOME}/.bashrc_local
    ```
- Activate the starship by running the following command inside the BLOX container
    ```console
    source .bashrc_local
    ```
