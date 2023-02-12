FROM docker.io/mikefarah/yq:4.30.8 as package_yq

FROM docker.io/alpine:3.17.2

COPY --from=package_yq /usr/bin/yq /bin/yq
COPY entrypoint.sh /entrypoint.sh

USER 65533

ENTRYPOINT ["/entrypoint.sh"]
