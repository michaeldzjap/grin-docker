# Multi-stage build, requires Docker >= 17.05

# 1. Build stage
FROM rust:latest as builder

# 1.1 Install all build requirements
RUN set -ex && \
    apt update && \
    apt --no-install-recommends --yes install \
    clang \
    libclang-dev \
    llvm-dev \
    libncurses5 \
    libncursesw5 \
    cmake \
    git

WORKDIR /usr/src

# 1.2 Clone and build the Grin server
RUN git clone https://github.com/mimblewimble/grin.git --branch v2.0.0 \
    && cd grin \
    && cargo build --release

# 2. Runtime stage
FROM debian:latest

# 2.1 Install and generate additional locales
RUN apt update && DEBIAN_FRONTEND=noninteractive && apt install -y locales openssl \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

COPY --from=builder /usr/src/grin/target/release/grin /usr/local/bin/grin

WORKDIR /root/.grin

VOLUME ["/root/.grin"]

# Copy entry point file and set correct permissions
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
