FROM alpine:3.13.6
MAINTAINER Gareth Luckett <gareth.luckett@gmail.com>

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-url="https://github.com/lareeth/alpine-ci-tools"

ARG KUBERNETES_VERSION=1.15.11
ARG HELM2_VERSION=2.16.3
ARG HELM3_VERSION=3.6.3
ARG AZURE_VERSION=2.27.2

RUN apk add --update curl bash git

# Kubernetes CLI
RUN if [ `uname -m` = "aarch64" ] ; then  \
        arch="arm64"; \
    else  \
        arch="amd64";  \
    fi && \
        curl -s -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/${arch}/kubectl && \
        chmod +x ./kubectl && \
        mv ./kubectl /usr/local/bin/kubectl

# Helm 2
RUN if [ `uname -m` = "aarch64" ] ; then  \
        arch="arm64"; \
    else \
        arch="amd64"; \
    fi && \
        curl -s -LO https://get.helm.sh/helm-v${HELM2_VERSION}-linux-${arch}.tar.gz && \
        tar -zxvf helm-v${HELM2_VERSION}-linux-${arch}.tar.gz && \
        mv linux-${arch}/helm /usr/local/bin/helm && \
        rm -rf helm-v${HELM2_VERSION}-linux-${arch}.tar.gz

# Helm 3
RUN if [ `uname -m` = "aarch64" ] ; then \
        arch="arm64"; \
    else \
        arch="amd64"; \
    fi && \
        curl -s -LO https://get.helm.sh/helm-v${HELM3_VERSION}-linux-${arch}.tar.gz && \
        tar -zxvf helm-v${HELM3_VERSION}-linux-${arch}.tar.gz && \
        mv linux-${arch}/helm /usr/local/bin/helm3 && \
        rm -rf helm-v${HELM3_VERSION}-linux-${arch}.tar.gz

# Azure CLI
RUN apk add --update py-pip && \
        apk add --update --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
        pip --no-cache-dir install azure-cli==${AZURE_VERSION} && \
        apk del --purge build

