ARG SUB_BASE_IMAGE=716533421362.dkr.ecr.us-east-1.amazonaws.com/phenompeople/debian-custom:13.3
FROM python:3.14.2-slim-bookworm@sha256:adb6bdfbcc7c744c3b1a05976136555e2d82b7df01ac3efe71737d7f95ef0f2d AS python-runtime

ENV PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    LANG="C.UTF-8" \
    PATH="/usr/local/bin:${PATH}"

RUN python --version && pip --version

FROM ${SUB_BASE_IMAGE}

ARG SUB_BASE_IMAGE
LABEL com.phenom.sub.base.image="716533421362.dkr.ecr.us-east-1.amazonaws.com/phenompeople/python-custom:3.13" \
      com.phenom.base.image="${SUB_BASE_IMAGE}" \
      com.phenom.fedramp.compliant=true

ENV LANG="C.UTF-8" \
    PATH="/usr/local/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1"

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        netbase \
        tzdata \
        libbz2-1.0 \
        libexpat1 \
        libffi8 \
        libgdbm6 \
        libgdbm-compat4 \
        liblzma5 \
        libncursesw6 \
        libreadline8 \
        libsqlite3-0 \
        libssl3 \
        zlib1g; \
    rm -rf /var/lib/apt/lists/*

COPY --from=python-runtime /usr/local /usr/local

RUN python --version && pip --version

HEALTHCHECK NONE

USER phenom
CMD ["python3"]
