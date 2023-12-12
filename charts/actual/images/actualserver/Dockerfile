FROM docker.io/library/alpine:3.19.0 as builder

# renovate: datasource=github-tags depName=actualbudget/actual-server versioning=semver extractVersion=^v(?<version>\S+)$
ARG ACTUAL_VERSION=23.12.1

# hadolint ignore=DL3018
RUN apk add --no-cache \
      nodejs yarn npm \
      python3 openssl \
      git build-base \
    && git clone --depth 1 --branch v${ACTUAL_VERSION} https://github.com/actualbudget/actual-server /build

WORKDIR /build
ENV NODE_ENV=production
# hadolint ignore=DL3016
RUN set -x \
    && npm install --global yarn-audit-fix \
    && npm_config_yes=true npx yarn-audit-fix \
    && yarn install

FROM docker.io/library/alpine:3.19.0

# renovate: datasource=github-tags depName=actualbudget/actual-server versioning=semver extractVersion=^v(?<version>\S+)$
ARG ACTUAL_VERSION=23.12.1

# hadolint ignore=DL3018
RUN adduser actual -u 64087 -g 64087 -s /bin/false -D -H \
    && apk upgrade --no-cache \
    && apk add --no-cache nodejs openssl tini
COPY --from=builder --chown=actual:actual /build /opt/actual

ENTRYPOINT ["tini", "-g", "--"]
CMD ["node", "/opt/actual/app.js"]
EXPOSE 5006
USER actual
VOLUME /opt/actual/server-files
VOLUME /opt/actual/user-files

LABEL org.opencontainers.image.authors="Beluga-Cloud <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created="01/01/1970T00:00:00.000"
LABEL org.opencontainers.image.description="Actual is a super fast privacy-focused app for managing your finances. You own your data, and we will sync it across all devices with optional end-to-end encryption."
LABEL org.opencontainers.image.documentation="https://actualbudget.com/docs/overview/getting-started"
LABEL org.opencontainers.image.licenses="GPL-2"
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.source=""
LABEL org.opencontainers.image.title="actualserver"
LABEL org.opencontainers.image.url="https://github.com/beluga-cloud/charts"
LABEL org.opencontainers.image.version=${ACTUAL_VERSION}

LABEL com.github.beluga-cloud.ci.workflow.url=""
LABEL com.github.beluga-cloud.origin.authors="actual <https://actualbudget.com>"
LABEL com.github.beluga-cloud.origin.licenses="MIT"
LABEL com.github.beluga-cloud.origin.source="https://github.com/actualbudget/actual"
