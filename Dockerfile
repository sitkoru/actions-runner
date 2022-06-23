FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GITHUB_CLI_VERSION=2.13.0

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
    python3 \
    cmake \
    xz-utils \
    lbzip2 \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb stable main" \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli $(apt-cache depends google-chrome-stable | grep Depends | sed -e "s/.*ends:\ //" -e 's/<[^>]*>//') libxss1 libxtst6 libx11-xcb1 \
    # Emscripten
    && mkdir /ems \
    && cd /ems \
    && git clone https://github.com/emscripten-core/emsdk.git \
    && cd /ems/emsdk \
    && ./emsdk install latest \
    && ./emsdk activate latest \
    # .NET
    && curl -L https://dot.net/v1/dotnet-install.sh -o /dotnet-install.sh \
    && chmod +x /dotnet-install.sh \
    && /dotnet-install.sh --channel 3.1 \
    && /dotnet-install.sh --channel 5.0 \
    && /dotnet-install.sh --channel 6.0 \
    && PATH="$PATH:/root/.dotnet" \
    && dotnet workload install wasm-tools \
    # GitHub Cli
    && curl -L https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.deb -o /tmp/gh_${GITHUB_CLI_VERSION}_linux_amd64.deb \
    && dpkg -i /tmp/gh_${GITHUB_CLI_VERSION}_linux_amd64.deb \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

ENV PATH "$PATH:/root/.dotnet"
