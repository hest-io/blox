###############################################################################
# AWSH Workspace - AWSH Toolset with IAC tools
###############################################################################
FROM "hestio/awsh:develop"


###############################################################################
# UUID ARGS to prevent Docker's inheritance from ruining our day
###############################################################################
ARG BLOX_BUILD_HTTP_PROXY
ARG BLOX_BUILD_HTTPS_PROXY
ARG BLOX_BUILD_NO_PROXY

###############################################################################
# ARGs
###############################################################################

ARG DML_BASE_URL_TF="https://releases.hashicorp.com/terraform"
ARG DML_BASE_URL_TFLINT="https://github.com/terraform-linters/tflint/releases/download"
ARG DML_BASE_URL_TERRAGRUNT="https://github.com/gruntwork-io/terragrunt/releases/download"
ARG BLOX_PYTHON_DEPS="requirements.blox"
ARG RUNTIME_PACKAGES="wget"
ARG TERRAFORM_VERSIONS="0.12.29 0.12.20 0.11.7 0.11.3"
ARG DEFAULT_TERRAFORM_VERSION="0.12.20"
ARG DEFAULT_TFLINT_VERSION="0.9.3"
ARG DEFAULT_PACKER_VERSION="1.6.0"
ARG DEFAULT_ANSIBLE_VERSION="2.7.8"
ARG DEFAULT_TERRAGRUNT_VERSIOn="v0.28.2"
ARG SW_VER_LANDSCAPE="0.3.2"

ARG CMD_PIP="python3 -m pip"

ARG AWSH_PIP_INSTALL_ARGS="--no-cache-dir --disable-pip-version-check"
ARG AWSH_GEM_INSTALL_ARGS="--no-document"

###############################################################################
# ENVs
###############################################################################
ENV AWSH_ROOT /opt/awsh
ENV AWSH_USER_HOME /home/awsh
ENV AWSH_USER awsh
ENV AWSH_GROUP awsh
ENV PUID 1000
ENV PGID 1000
ENV PYTHONPATH /opt/awsh/lib/python3
ENV PATH "/opt/awsh/bin:/opt/awsh/bin/tools:${PATH}:${AWSH_USER_HOME}/bin"

ENV DEFAULT_TERRAFORM_VERSION ${DEFAULT_TERRAFORM_VERSION}

###############################################################################
# LABELs
###############################################################################

USER root

# Add new entrypoint
COPY lib/docker/entrypoint.sh /opt/awsh/lib/docker/entrypoint.sh

# Add the Terraform CLI config and ensure the cache dir exists
COPY lib/docker/terraformrc "${AWSH_USER_HOME}/.terraformrc"
RUN mkdir -p "${AWSH_USER_HOME}/.terraform.d/plugin-cache"

# Add Python packages
COPY requirements/ /tmp
RUN ${CMD_PIP} install ${AWSH_PIP_INSTALL_ARGS} -r "/tmp/${BLOX_PYTHON_DEPS}"

# Add Packer
RUN \
    cd /usr/local/bin && \
    curl -sSL -x "${BLOX_BUILD_HTTPS_PROXY}" -o "packer_1.6.0_linux_amd64.zip" "https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip"  && \
    unzip "packer_1.6.0_linux_amd64.zip" && \
    rm "packer_1.6.0_linux_amd64.zip"

# Add Terraform versions
RUN \
    cd /usr/local/bin && \
    for tfver in ${TERRAFORM_VERSIONS}; do \
        curl -sSL -x "${BLOX_BUILD_HTTPS_PROXY}" -o "terraform_${tfver}_linux_amd64.zip" "https://releases.hashicorp.com/terraform/${tfver}/terraform_${tfver}_linux_amd64.zip"; \
        unzip "terraform_${tfver}_linux_amd64.zip"; \
        mv terraform "terraform-${tfver}"; \
        rm "terraform_${tfver}_linux_amd64.zip"; \
    done

# Add TF-Lint
RUN \
    cd /usr/local/bin && \
    curl -sSL -x "${BLOX_BUILD_HTTPS_PROXY}" -o "tflint_linux_amd64.zip" "${DML_BASE_URL_TFLINT}/v${DEFAULT_TFLINT_VERSION}/tflint_linux_amd64.zip"  && \
    unzip "tflint_linux_amd64.zip" && \
    rm "tflint_linux_amd64.zip"

# Add Terragrunt CLI
RUN \
    cd /usr/local/bin && \
    curl -sSL -x "${BLOX_BUILD_HTTPS_PROXY}" -o "terragrunt_linux_amd64" "${DML_BASE_URL_TERRAGRUNT}/v${DEFAULT_TFLINT_VERSION}/terragrunt_linux_amd64"  && \
    mv "terragrunt_linux_amd64" "terragrunt" && \
    chmod 755 terragrunt

# Add landscape
RUN http_proxy="${BLOX_BUILD_HTTP_PROXY}" https_proxy="${BLOX_BUILD_HTTP_PROXY}" gem install terraform_landscape --version ${SW_VER_LANDSCAPE} ${AWSH_GEM_INSTALL_ARGS}

# Add AMI Cleaner
RUN ${CMD_PIP} install ${AWSH_PIP_INSTALL_ARGS} git+https://github.com/kirklatslalom/aws-amicleaner.git

COPY bin/ "${AWSH_USER_HOME}/bin/"
COPY etc/ "${AWSH_USER_HOME}/etc/"

# Ensure ownership of AWSH paths
RUN \
    chown -c -R ${AWSH_USER}:${AWSH_GROUP} ${AWSH_ROOT} && \
    chown -c -R ${AWSH_USER}:${AWSH_GROUP} ${AWSH_USER_HOME}

# Add hook for AWSH that activates during CICD usage
RUN echo '. /opt/awsh/etc/awshrc' >> /etc/profile.d/entrypoint.sh
RUN echo '[ -f ${HOME}/.bashrc_local ] && . ${HOME}/.bashrc_local' >> /etc/profile.d/entrypoint.sh

WORKDIR ${AWSH_USER_HOME}
USER awsh

ENTRYPOINT ["/opt/awsh/lib/docker/entrypoint.sh"]
CMD ["/bin/bash", "-i"]

