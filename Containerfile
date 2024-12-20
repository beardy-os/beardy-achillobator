ARG BASE_VERSION="${MAJOR_VERSION:-latest}"
ARG BASE_IMAGE="ghcr.io/centos-workstation/achillobator"
ARG CACHE_ID_SUFFIX="beardy-achillobator-latest"

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${BASE_VERSION}

ARG IMAGE_NAME="${IMAGE_NAME:-beardy-achillobator}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-beardy-os}"
ARG MAJOR_VERSION="${MAJOR_VERSION:-latest}"

RUN ln -sf /run /var/run

RUN \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    mkdir -p /var/lib/alternatives && \
    /ctx/build.sh && \
    dnf clean all && \
    ostree container commit

RUN bootc container lint