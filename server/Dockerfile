# Multi-stage build, requires Docker >= 17.05

# 1. Build stage
FROM rust:latest as builder

# 1.1 Install all build requirements
RUN set -ex && \
    apt update && \
    apt --no-install-recommends --yes install \
    build-essential \
    cmake \
    git \
    libgit2-dev \
    clang \
    libncurses5-dev \
    libncursesw5-dev \
    zlib1g-dev \
    pkg-config \
    libssl-dev \
    llvm

WORKDIR /usr/src

# 1.2 Clone and build the Grin server
RUN git clone https://github.com/mimblewimble/grin.git --branch v2.0.0-beta.2 \
    && cd grin \
    && cargo build --release

# 2. Runtime stage
FROM debian:latest

# 2.1 Install and generate additional locales
RUN apt update && apt install -y locales openssl \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

COPY --from=builder /usr/src/grin/target/release/grin /usr/local/bin/grin

WORKDIR /root/.grin

VOLUME ["/root/.grin"]

# Copy entry point file and set correct permissions
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
