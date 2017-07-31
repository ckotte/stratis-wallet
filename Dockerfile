FROM debian:jessie-slim
MAINTAINER Christian Kotte <prism42@icloud.com>

# permissions
ARG CONTAINER_UID=1000
ARG CONTAINER_GID=1000

# Setup useful environment variables
ENV STRATIS_PACKAGE=stratisX
ENV STRATIS_REPO=https://github.com/stratisproject/${STRATIS_PACKAGE}.git \
    STRATIS_DATA_DIR=/var/lib/stratis \
    STRATIS_RUN_DIR=/var/run/stratis

COPY imagescripts/* /usr/bin/

# Install stratisX
RUN export CONTAINER_USER=stratis && \
    export CONTAINER_GROUP=stratis && \
    addgroup --gid $CONTAINER_GID $CONTAINER_GROUP && \
    adduser --uid $CONTAINER_UID \
            --ingroup $CONTAINER_GROUP \
            --home /home/$CONTAINER_USER \
            --shell /bin/bash \
            --system $CONTAINER_USER && \
    # Install packages
    apt-get update && apt-get install -y \
      build-essential \
      git \
      g++ \
      libtool \
      make \
      libboost-all-dev \
      libssl-dev \
      libdb++-dev \
      libdb5.3++-dev \
      libdb5.3-dev \
      libminiupnpc-dev \
      libqrencode-dev \
      wget \
      unzip \
      vim && \
    # Clone and build from source
    cd /tmp && \
    git clone $STRATIS_REPO && \
    cd $STRATIS_PACKAGE/src && \
    make -f makefile.unix && \
    strip stratisd && \
    # Install stratisd to /usr/bin
    mv stratisd /usr/bin && \
    chmod +x /usr/bin/stratisd-* && \
    mkdir -p $STRATIS_RUN_DIR && \
    mkdir -p $STRATIS_DATA_DIR && \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/$STRATIS_PACKAGE

# Make default port available
EXPOSE 16174

USER stratis
WORKDIR ${STRATIS_RUN_DIR}
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
