FROM docker.io/library/ubuntu:kinetic

ARG DEBIAN_FRONTEND="noninteractive"

# renovate: datasource=github-releases depName=prowlarr/prowlarr versioning=semver
ARG PROWLARR_VERSION="1.4.1.3258"

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get upgrade --assume-yes --no-install-recommends \
    && apt-get install --assume-yes --no-install-recommends \
      ca-certificates \
      gnupg \
      wget \
    && rm --recursive --force /tmp/* /var/lib/apt/lists/* /var/tmp/*

# hadolint ignore=DL3008
RUN groupadd prowlarr --gid 64037 \
    && useradd prowlarr --uid 64037 --gid 64037 \
      --system --no-create-home --shell /bin/false \
      --comment "Prowlarr default user" \
    \
    && apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
      libicu71 \
      libsqlite3-0 \
    && mkdir --parent /opt/prowlarr/bin /opt/prowlarr/data \
    && wget --quiet "https://github.com/Prowlarr/Prowlarr/releases/download/v${PROWLARR_VERSION}/Prowlarr.master.${PROWLARR_VERSION}.linux-core-$(dpkg --print-architecture | sed 's/amd/x/').tar.gz" --output-document=- \
      | tar --extract --gzip --directory=/opt/prowlarr/bin --strip-components=1 \
    && printf '%s' "UpdateMethod=docker\nUpdateMethodMessage=update the docker container or the Helm chart to receive the update\nBranch=main\nPackageVersion=${PROWLARR_VERSION}\nPackageAuthor=[beluga-cloud](https://github.com/beluga-cloud/charts)" > /opt/prowlarr/package_info \
    && rm --recursive --force /opt/prowlarr/bin/Prowlarr.Update \
    \
    && chown prowlarr:prowlarr --recursive /opt/prowlarr \
    && rm --recursive --force /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Disable .NET debugging telemetry (required to run on Kubernetes with read-only root filesystem)
ENV COMPlus_EnableDiagnostics=0

ENTRYPOINT ["/opt/prowlarr/bin/Prowlarr", "/nobrowser", "/data=/opt/prowlarr/data"]
EXPOSE 9696/tcp
USER prowlarr
VOLUME ["/opt/prowlarr/data"]

LABEL org.opencontainers.image.authors="Beluga-Cloud <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created="01/01/1970T00:00:00.000"
LABEL org.opencontainers.image.description="Prowlarr is an indexer manager/proxy built on the popular *arr."
LABEL org.opencontainers.image.documentation="https://wiki.servarr.com/prowlarr"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.source=""
LABEL org.opencontainers.image.title="prowlarr"
LABEL org.opencontainers.image.url="https://github.com/beluga-cloud/charts"
LABEL org.opencontainers.image.version=${PROWLARR_VERSION}

LABEL com.github.beluga-cloud.ci.workflow.url=""
LABEL com.github.beluga-cloud.origin.authors="Sonarr Community <https://prowlarr.com>"
LABEL com.github.beluga-cloud.origin.licenses="GPL-3.0"
LABEL com.github.beluga-cloud.origin.source="https://github.com/Prowlarr/Prowlarr"
