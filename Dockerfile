FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        apt-utils \
        software-properties-common \
        apt-transport-https \
        unzip \
        gnupg2 \
        # .NET dependencies
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu66 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
        liblttng-ust-ctl4 \
        rsync \
        openssh-client \
        sudo \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb stable main" \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli `apt-cache depends google-chrome-stable | awk '/Depends:/{print$2}'` libxss1 libxtst6 libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*
