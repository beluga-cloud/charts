FROM quay.io/jetstack/cert-manager-controller:v1.10.1

ARG BUILD_DATE="01/01/1970T00:00:00.000"
ARG BUILD_REF="refs/HEAD"
ARG BUILD_SHA=""
ARG BUILD_SOURCE_URL="https://github.com/belug-apps/catalog/tree/main/images/cert-manager/controller"
ARG BUILD_VERSION="latest"
ARG BUILD_WORKFLOW_URL=""

LABEL org.opencontainers.image.authors="Belug-Apps <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.description="cert-manager is a Kubernetes addon to automate the management and issuance of TLS certificates from various issuing sources."
LABEL org.opencontainers.image.documentation=""
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.ref.name=$BUILD_REF
LABEL org.opencontainers.image.revision=$BUILD_SHA
LABEL org.opencontainers.image.source=$BUILD_SOURCE_URL
LABEL org.opencontainers.image.title="cert-manager"
LABEL org.opencontainers.image.url="https://github.com/belug-apps/catalog/tree/main/images/cert-manager/controller/Dockerfile"
LABEL org.opencontainers.image.version=$BUILD_VERSION

LABEL com.github.belug-apps.ci.workflow.url=$BUILD_WORKFLOW_URL
LABEL com.github.belug-apps.origin.authors="JetStack <www.jetstack.io> & cert-manager community <cert-manager.io>"
LABEL com.github.belug-apps.origin.licenses="Apache-2.0"
LABEL com.github.belug-apps.origin.source="https://github.com/cert-manager/cert-manager/blob/master/hack/containers/Containerfile.controller"

USER 1000
