FROM docker.io/library/golang:1.20.4 as builder

# renovate: datasource=docker depName=komodorio/helm-dashboard versioning=semver
ARG HELM_DASHBOARD_VERSION=1.3.1

WORKDIR /build
RUN git clone https://github.com/komodorio/helm-dashboard --branch v${HELM_DASHBOARD_VERSION}

WORKDIR /build/helm-dashboard
RUN CGO_ENABLED=0 go build \
    -ldflags "-X main.version=${HELM_DASHBOARD_VERSION} -X main.date=$(date --iso-8601=ns) -X main.commit=$(git rev-parse HEAD)" \
    -o ../dashboard .

FROM docker.io/alpine/helm:3.11.3 as helm_packager
FROM docker.io/bitnami/kubectl:1.27.1 as kubectl_packager
FROM docker.io/aquasec/trivy:0.41.0 as trivy_packager

FROM docker.io/alpine:3.18.0

# renovate: datasource=docker depName=komodorio/helm-dashboard versioning=semver
ARG HELM_DASHBOARD_VERSION=1.3.1

RUN apk upgrade --no-cache
COPY --from=builder /build/dashboard /bin/helm-dashboard
COPY --from=helm_packager /usr/bin/helm /bin/helm
COPY --from=kubectl_packager /opt/bitnami/kubectl/bin/kubectl /bin/kubectl
COPY --from=trivy_packager /usr/local/bin/trivy /bin/trivy

USER 65533

EXPOSE 8080
ENTRYPOINT ["/bin/helm-dashboard", "--no-browser", "--bind=0.0.0.0"]

LABEL org.opencontainers.image.authors="Beluga-Cloud <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created="01/01/1970T00:00:00.000"
LABEL org.opencontainers.image.description="The missing UI for Helm - visualize your releases."
LABEL org.opencontainers.image.documentation=""
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.source=""
LABEL org.opencontainers.image.title="helm-dashboard"
LABEL org.opencontainers.image.url="https://github.com/beluga-cloud/charts"
LABEL org.opencontainers.image.version=${HELM_DASHBOARD_VERSION}

LABEL com.github.beluga-cloud.ci.workflow.url=""
LABEL com.github.beluga-cloud.origin.authors="komodor <komodor.io>"
LABEL com.github.beluga-cloud.origin.licenses="Apache-2.0"
LABEL com.github.beluga-cloud.origin.source="https://github.com/komodorio/helm-dashboard"
