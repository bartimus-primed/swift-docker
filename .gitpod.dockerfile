FROM gitpod/workspace-full:latest

USER root
# Install custom tools, runtime, etc.

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libatomic1 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libpython2.7 \
    tzdata \
    git \
    pkg-config \
    clang \
    && rm -r /var/lib/apt/lists/*


RUN set -e; \
    SWIFT_BIN_URL="https://swift.org/builds/swift-5.1.1-release/ubuntu1804/swift-5.1.1-RELEASE/swift-5.1.1-RELEASE-ubuntu18.04.tar.gz" \
    # - Grab curl here so we cache better up above
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -q update && apt-get -q install -y curl && rm -rf /var/lib/apt/lists/* \
    # - Download the GPG keys, Swift toolchain, and toolchain signature, and verify.
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz \
    # - Unpack the toolchain, set libs permissions, and clean up.
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift \
    && apt-get purge --auto-remove -y
