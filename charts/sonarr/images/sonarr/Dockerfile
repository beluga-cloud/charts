FROM docker.io/library/ubuntu:kinetic

ARG DEBIAN_FRONTEND="noninteractive"

# renovate: datasource=github-tags depName=sonarr/sonarr versioning=semver
ARG SONARR_VERSION="3.0.10.1567"

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get upgrade --assume-yes --no-install-recommends \
    && apt-get install --assume-yes --no-install-recommends \
      ca-certificates \
      gnupg \
      wget \
    && rm --recursive --force /tmp/* /var/lib/apt/lists/* /var/tmp/*

# hadolint ignore=DL3008
RUN groupadd sonarr --gid 64085 \
    && useradd sonarr --uid 64085 --gid 64085 \
      --system --no-create-home --shell /bin/false \
      --comment "Sonarr default user" \
    \
    && gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && printf '%s' "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
      ca-certificates-mono \
      libmono-corlib4.5-cil \
      libmono-microsoft-csharp4.0-cil \
      libmono-posix4.0-cil \
      libmono-system-componentmodel-dataannotations4.0-cil \
      libmono-system-configuration-install4.0-cil \
      libmono-system-configuration4.0-cil \
      libmono-system-core4.0-cil \
      libmono-system-data-datasetextensions4.0-cil \
      libmono-system-data4.0-cil \
      libmono-system-identitymodel4.0-cil \
      libmono-system-io-compression4.0-cil \
      libmono-system-net-http4.0-cil \
      libmono-system-numerics4.0-cil \
      libmono-system-runtime-serialization4.0-cil \
      libmono-system-security4.0-cil \
      libmono-system-servicemodel4.0a-cil \
      libmono-system-serviceprocess4.0-cil \
      libmono-system-transactions4.0-cil \
      libmono-system-web4.0-cil \
      libmono-system-xml-linq4.0-cil \
      libmono-system-xml4.0-cil \
      libmono-system4.0-cil \
      mediainfo \
      mono-runtime \
      mono-vbnc \
    && mkdir --parent /opt/sonarr/bin /opt/sonarr/data \
    && wget --quiet "https://download.sonarr.tv/v3/main/${SONARR_VERSION}/Sonarr.main.${SONARR_VERSION}.linux.tar.gz" --output-document=- \
      | tar --extract --gzip --directory=/opt/sonarr/bin --strip-components=1 \
    && printf '%s' "UpdateMethod=docker\nUpdateMethodMessage=update the docker container or the Helm chart to receive the update\nBranch=main\nPackageVersion=${SONARR_VERSION}\nPackageAuthor=[beluga-cloud](https://github.com/beluga-cloud/charts)" > /opt/sonarr/package_info \
    && rm --recursive --force /opt/sonarr/bin/Sonarr.Update \
    \
    && chown sonarr:sonarr --recursive /opt/sonarr \
    && rm --recursive --force /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENTRYPOINT ["/usr/bin/mono", "--debug", "/opt/sonarr/bin/Sonarr.exe", "--no-browser", "--data=/opt/sonarr/data"]
EXPOSE 8989/tcp
USER sonarr
VOLUME ["/opt/sonarr/data"]

LABEL org.opencontainers.image.authors="Beluga-Cloud <xunleii@users.noreply.github.com>"
LABEL org.opencontainers.image.created="01/01/1970T00:00:00.000"
LABEL org.opencontainers.image.description="Sonarr is a PVR for Usenet and BitTorrent users."
LABEL org.opencontainers.image.documentation="https://wiki.servarr.com/sonarr"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.revision=""
LABEL org.opencontainers.image.source=""
LABEL org.opencontainers.image.title="sonarr"
LABEL org.opencontainers.image.url="https://github.com/beluga-cloud/charts"
LABEL org.opencontainers.image.version=${SONARR_VERSION}

LABEL com.github.beluga-cloud.ci.workflow.url=""
LABEL com.github.beluga-cloud.origin.authors="Sonarr Community <https://sonarr.tv>"
LABEL com.github.beluga-cloud.origin.licenses="GPL-3.0"
LABEL com.github.beluga-cloud.origin.source="https://github.com/Sonarr/Sonarr"
