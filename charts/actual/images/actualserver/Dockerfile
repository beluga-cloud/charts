FROM docker.io/library/alpine:3.19.1 as builder

# renovate: datasource=github-tags depName=actualbudget/actual-server versioning=semver
ARG ACTUAL_VERSION=v23.12.1

# renovate: datasource=repology depName=alpine_3_19/nodejs versioning=semver
ARG NODEJS_VERSION=20.12.1-r0
# renovate: datasource=repology depName=alpine_3_19/yarn versioning=semver
ARG YARN_VERSION=1.22.19-r0
# renovate: datasource=repology depName=alpine_3_19/npm versioning=semver
ARG NPM_VERSION=10.2.5-r0
# renovate: datasource=repology depName=alpine_3_19/git versioning=semver
ARG GIT_VERSION=2.43.0-r0
# renovate: datasource=repology depName=alpine_3_19/build-base versioning=semver
ARG BUILD_BASE_VERSION=0.5-r3

# hadolint ignore=DL3018
RUN apk add --no-cache \
        nodejs=${NODEJS_VERSION} \
        yarn=${YARN_VERSION} \
        npm=${NPM_VERSION} \
        git=${GIT_VERSION} \
        build-base=${BUILD_BASE_VERSION} \
    && git clone --depth 1 --branch ${ACTUAL_VERSION} https://github.com/actualbudget/actual-server /build

WORKDIR /build
ENV NODE_ENV=production
# hadolint ignore=DL3016
RUN set -x \
    && yarn workspaces focus --all --production


FROM scratch as bundle
COPY --from=builder /build/app.js /build/package.json /
COPY --from=builder /build/migrations /migrations
COPY --from=builder /build/node_modules /node_modules
COPY --from=builder /build/src /src


FROM docker.io/library/alpine:3.19.1

# renovate: datasource=github-tags depName=actualbudget/actual-server versioning=semver extractVersion=^v(?<version>\S+)$
ARG ACTUAL_VERSION=23.12.1

# renovate: datasource=repology depName=alpine_3_19/nodejs versioning=semver
ARG NODEJS_VERSION=20.12.1-r0
# renovate: datasource=repology depName=alpine_3_19/openssl versioning=semver
ARG OPENSSL_VERSION=3.1.4-r6
# renovate: datasource=repology depName=alpine_3_19/tini versioning=semver
ARG TINI_VERSION=0.19.0-r2

# hadolint ignore=DL3018
RUN apk add --no-cache \
        nodejs=${NODEJS_VERSION} \
        openssl=${OPENSSL_VERSION} \
        tini=${TINI_VERSION} \
    && adduser actual -u 64087 -g 64087 -s /bin/false -D -H \
    && mkdir --parent /opt/data /data/server-files /data/user-files \
    && chown --recursive actual:actual /data

COPY --from=bundle --chown=actual:actual / /opt/actual

USER actual
WORKDIR /opt/actual
ENTRYPOINT ["tini", "-g", "--"]
CMD ["node", "app.js"]

EXPOSE 5006
VOLUME /data/server-files
VOLUME /data/user-files

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
