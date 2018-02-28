FROM debian:jessie
MAINTAINER Lucas Souza <lucasvs@outlook.com>

RUN useradd --system asterisk

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -yq --no-install-recommends \
            subversion \
            automake \
            aptitude \
            autoconf \
            binutils-dev \
            build-essential \
            ca-certificates \
            curl \
            libcurl4-openssl-dev \
            libedit-dev \
            libgsm1-dev \
            libjansson-dev \
            libogg-dev \
            libpopt-dev \
            libresample1-dev \
            libspandsp-dev \
            libspeex-dev \
            libspeexdsp-dev \
            libsqlite3-dev \
            libsrtp0-dev \
            libssl-dev \
            libvorbis-dev \
            libxml2-dev \
            libxslt1-dev \
            portaudio19-dev \
            python-pip \
            unixodbc-dev \
            uuid \
            uuid-dev \
            xmlstarlet \
            unixodbc \
            unixodbc-dev \
            libmyodbc \
            python-dev \
            python-pip \
            python-mysqldb \
            git \
            wget \
            sox \
            libsox-fmt-mp3 \
            vim \
            && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* && \
    pip install alembic

## Install sngrep
RUN echo 'deb http://packages.irontec.com/debian jessie main' >> /etc/apt/sources.list && \
    apt-get update && apt-get -y -q install wget && \
    wget http://packages.irontec.com/public.key -q -O - | apt-key add - && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -yq sngrep

ENV ASTERISK_VERSION=14.7.6 PJPROJECT_VERSION=2.7.2
COPY build-asterisk.sh /build-asterisk
RUN /build-asterisk

CMD ["/usr/sbin/asterisk", "-f"]