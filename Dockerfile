FROM alpine:3
MAINTAINER Gareth Luckett <gareth.luckett@gmail.com>

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/lareeth/alpine-ci-tools"

ARG TARGETARCH
ARG KUBERNETES_VERSION=1.15.11
ARG HELM2_VERSION=2.16.3
ARG HELM3_VERSION=3.1.2
ARG AZURE_VERSION=2.27.2

RUN apk add --update curl bash git

# Kubernetes CLI
RUN curl -s -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/${TARGETARCH}/kubectl && \
	chmod +x ./kubectl && \
	mv ./kubectl /usr/local/bin/kubectl

# Helm 2
RUN curl -s -LO https://get.helm.sh/helm-v${HELM2_VERSION}-linux-${TARGETARCH}.tar.gz && \
	tar -zxvf helm-v${HELM2_VERSION}-linux-${TARGETARCH}.tar.gz && \
	mv linux-${TARGETARCH}/helm /usr/local/bin/helm && \
	rm -rf helm-v${HELM2_VERSION}-linux-${TARGETARCH}.tar.gz

# Helm 3
RUN curl -s -LO https://get.helm.sh/helm-v${HELM3_VERSION}-linux-${TARGETARCH}.tar.gz && \
	tar -zxvf helm-v${HELM3_VERSION}-linux-${TARGETARCH}.tar.gz && \
	mv linux-${TARGETARCH}/helm /usr/local/bin/helm3 && \
	rm -rf helm-v${HELM3_VERSION}-linux-${TARGETARCH}.tar.gz

# Azure CLI
RUN apk add --update python3 py3-pip py3-pynacl py3-cryptography py3-bcrypt py3-yaml py3-psutil py3-wrapt && \
	apk add --update --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev py3-wheel make && \
	pip --no-cache-dir install azure-cli==${AZURE_VERSION} && \
	apk del --purge build

RUN kubectl version --client
RUN helm version --client
RUN helm3 version --client
RUN az --version
