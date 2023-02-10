FROM docker.io/library/golang:1.19.4 as builder

# renovate: datasource=github-release depName=komodorio/helm-dashboard versioning=semver
ARG HELM_DASHBOARD_VERSION=v0.3.1

WORKDIR /build
RUN git clone https://github.com/komodorio/helm-dashboard --branch ${HELM_DASHBOARD_VERSION}

WORKDIR /build/helm-dashboard
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN CGO_ENABLED=0 go build \
    -ldflags "-X main.version=${HELM_DASHBOARD_VERSION} -X main.date=$(date --iso-8601=ns) -X main.commit=$(git rev-parse HEAD)" \
    -o ../dashboard .

FROM docker.io/alpine/helm:3.10.2

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3013,DL3018
RUN apk add --update --no-cache python3 \
    && python3 -m ensurepip \
    && pip3 install --upgrade --no-cache-dir pip setuptools

# renovate: datasource=github-release depName=komodorio/helm-dashboard versioning=semver
ARG HELM_DASHBOARD_VERSION=v1.0.0
# renovate: datasource=github-tags depName=kubernetes/kubectl versioning=semver
ARG KUBECTL_VERSION=v1.26.1
# renovate: datasource=github-release depName=aquasecurity/trivy versioning=semver
ARG TRIVY_VERSION=v0.18.3

RUN curl --output /bin/kubectl --verbose --fail --location "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
      && chmod +x /bin/kubectl \
      && kubectl version --client \
    && curl --silent --fail --location https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
      | sh -s -- -b /usr/local/bin ${TRIVY_VERSION} \
      && trivy --version

COPY --from=builder /build/dashboard /bin/helm-dashboard
USER 65533

EXPOSE 8080
ENTRYPOINT ["/bin/helm-dashboard", "--no-browser", "--bind=0.0.0.0"]

LABEL org.opencontainers.image.authors="Belug-Apps <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created="01/01/1970T00:00:00.000"
LABEL org.opencontainers.image.description="The missing UI for Helm - visualize your releases."
LABEL org.opencontainers.image.documentation=""
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.source=""
LABEL org.opencontainers.image.title="helm-dashboard"
LABEL org.opencontainers.image.url="https://github.com/belug-apps/catalog"
LABEL org.opencontainers.image.version=${HELM_DASHBOARD_VERSION}

LABEL com.github.belug-apps.ci.workflow.url=""
LABEL com.github.belug-apps.origin.authors="komodor <komodor.io>"
LABEL com.github.belug-apps.origin.licenses="Apache-2.0"
LABEL com.github.belug-apps.origin.source="https://github.com/komodorio/helm-dashboard"
