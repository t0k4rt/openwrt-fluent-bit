From buildpack-deps:stretch-curl

MAINTAINER Terrence Lam <skyuplam@gmail.com>

ENV OPENWRT_VERSION=19.07.2
ENV OPENWRT_BASE_URL=https://downloads.openwrt.org/releases
ENV OPENWRT_TARGET=ipq40xx
ENV OPENWRT_SUBTARGET=generic
ENV OPENWRT_URL=${OPENWRT_BASE_URL}/${OPENWRT_VERSION}/targets/${OPENWRT_TARGET}/${OPENWRT_SUBTARGET}
ENV OPENWRT_GCC_VERSION=7.5.0
ENV OPENWRT_MUSL_VERSION=1.2.0
ENV OPENWRT_SDK=openwrt-sdk-${OPENWRT_VERSION}-${OPENWRT_TARGET}-${OPENWRT_SUBTARGET}_gcc-${OPENWRT_GCC_VERSION}_musl_eabi.Linux-x86_64
ENV OPENWRT_SDK_URL=${OPENWRT_URL}/${OPENWRT_SDK}.tar.xz
ENV OPENWRT_ARCH=arm_cortex-a7+neon-vfpv4
ENV OPENWRT_TOOLCHAIN=toolchain-${OPENWRT_ARCH}_gcc-${OPENWRT_GCC_VERSION}_musl_eabi

ENV STAGING_DIR=/home/openwrt/sdk/staging_dir
ENV OPENWRT_TOOLCHAIN_DIR=${STAGING_DIR}/${OPENWRT_TOOLCHAIN}
ENV PATH=${PATH}:${STAGING_DIR}/host/bin:${OPENWRT_TOOLCHAIN_DIR}/bin

RUN set -xe \
  && apt-get update \
  && apt-get install -y build-essential \
                        cmake \
                        ccache \
                        curl \
                        file \
                        gawk \
                        gettext \
                        git \
                        libncurses5-dev \
                        libssl-dev \
                        mercurial \
                        python \
                        subversion \
                        sudo \
                        tree \
                        unzip \
                        wget \
                        vim-tiny \
                        xsltproc \
                        zlib1g-dev \
  && useradd -m openwrt \
  && echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt
WORKDIR /home/openwrt

RUN set -xe \
  && curl -sSL ${OPENWRT_SDK_URL} | tar -xJ \
  && ln -s ${OPENWRT_SDK} sdk

ENV FLUENTBIT_VERSION=1.4.1
ENV FLUENTBIT_URL=https://github.com/fluent/fluent-bit/archive/v${FLUENTBIT_VERSION}.tar.gz

RUN set -xe \
  && curl -sSL ${FLUENTBIT_URL} | tar -xz \
  && ln -s fluent-bit-${FLUENTBIT_VERSION} fluent-bit


COPY ./openwrt.cmake /home/openwrt/

CMD ["bash"]
