FROM docker.io/mikefarah/yq:4.30.8 as package_yq

FROM docker.io/alpine:3.17.2

COPY --from=package_yq /usr/bin/yq /bin/yq
COPY entrypoint.sh /entrypoint.sh

USER 65533

ENTRYPOINT ["/entrypoint.sh"]

LABEL org.opencontainers.image.authors="Belug-Apps <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created="01/01/1970T00:00:00.000"
LABEL org.opencontainers.image.description="Helm repositories preloader for helm-dashboard."
LABEL org.opencontainers.image.documentation=""
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.source=""
LABEL org.opencontainers.image.title="helm-dashboard"
LABEL org.opencontainers.image.url="https://github.com/belug-apps/catalog"
LABEL org.opencontainers.image.version="1.0.0"

LABEL com.github.belug-apps.ci.workflow.url=""
