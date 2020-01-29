###############################################################################
# AWSH Workspace - AWSH Toolset with IAC tools
###############################################################################
FROM "awsh:local"

###############################################################################
# ARGs
###############################################################################
ARG HTTP_PROXY="${http_proxy}"
ARG http_proxy="${http_proxy}"
ARG HTTPS_PROXY="${https_proxy}"
ARG https_proxy="${https_proxy}"
ARG no_proxy="${no_proxy}"
ARG NO_PROXY="${NO_PROXY}"
ARG DML_BASE_URL_TF="https://releases.hashicorp.com/terraform"
ARG DML_BASE_URL_TFLINT="https://github.com/terraform-linters/tflint/releases/download"
ARG AWSH_PYTHON_DEPS="/tmp/requirements.python2"

ARG DEFAULT_TERRAFORM_VERSION="0.11.3"
ARG DEFAULT_TFLINT_VERSION="0.9.3"

ARG SW_VER_LANDSCAPE="0.3.2"

###############################################################################
# ENVs
###############################################################################
ENV AWSH_ROOT /opt/awsh
ENV AWSH_USER_HOME /home/awsh
ENV AWSH_USER awsh
ENV AWSH_GROUP awsh
ENV PUID 1000
ENV PGID 1000
ENV PYTHONPATH /opt/awsh/lib/python
ENV PATH "/opt/awsh/bin:/opt/awsh/bin/tools:${PATH}:${AWSH_USER_HOME}/bin"
ENV HTTP_PROXY "${http_proxy}"
ENV http_proxy "${http_proxy}"
ENV HTTPS_PROXY "${https_proxy}"
ENV https_proxy "${https_proxy}"
ENV no_proxy "${no_proxy}"
ENV NO_PROXY "${NO_PROXY}"

###############################################################################
# LABELs
###############################################################################

USER root

# Install TF 0.12.x
ARG TERRAFORM_VERSION=0.12.7

RUN \
    cd /usr/local/bin && \
    curl "${DML_BASE_URL_TF}/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    mv terraform "terraform-${TERRAFORM_VERSION}" && \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Install TF 0.11.x (11.x release with reasonable backwards compatibility)
ARG TERRAFORM_VERSION=0.11.3

RUN \
    cd /usr/local/bin && \
    curl "${DML_BASE_URL_TF}/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    mv terraform "terraform-${TERRAFORM_VERSION}" && \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Install TF 0.11.7 (first 11.x release with provider breaking changes)
ARG TERRAFORM_VERSION=0.11.7

RUN \
    cd /usr/local/bin && \
    curl "${DML_BASE_URL_TF}/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    mv terraform "terraform-${TERRAFORM_VERSION}" && \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Link the default TF version
RUN ln -s "/usr/local/bin/terraform-${DEFAULT_TERRAFORM_VERSION}" "/usr/local/bin/terraform" 

# Add TF-Lint
RUN \
    cd /usr/local/bin && \
    curl -L "${DML_BASE_URL_TFLINT}/v${DEFAULT_TFLINT_VERSION}/tflint_linux_amd64.zip" -o "terraform_${DEFAULT_TFLINT_VERSION}_linux_amd64.zip" && \
    unzip "terraform_${DEFAULT_TFLINT_VERSION}_linux_amd64.zip" && \
    rm "terraform_${DEFAULT_TFLINT_VERSION}_linux_amd64.zip"

# Add landscape
RUN gem install terraform_landscape --version ${SW_VER_LANDSCAPE} --no-ri --no-rdoc

COPY bin/ "${AWSH_USER_HOME}/bin/"
COPY etc/ "${AWSH_USER_HOME}/etc/"

# Ensure ownership of AWSH paths
RUN \
    chown -c -R ${AWSH_USER}:${AWSH_GROUP} ${AWSH_ROOT} && \
    chown -c -R ${AWSH_USER}:${AWSH_GROUP} ${AWSH_USER_HOME}


WORKDIR ${AWSH_USER_HOME}

ENTRYPOINT ["fixuid"]

CMD ["-q", "/bin/bash"]

USER ${AWSH_USER}:${AWSH_GROUP}
