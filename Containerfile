ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/x11appjail-base:${FREEBSD_RELEASE}-x11

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Feh" \
    org.opencontainers.image.description="Image viewer that utilizes Imlib2" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/feh" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/feh" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    sysrc clear_tmp_X=NO; \
    \
    pkg update; \
    pkg install feh bash; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*
