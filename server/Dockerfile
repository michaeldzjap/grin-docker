# Multi-stage build, requires Docker >= 17.05

# 1. Build stage
FROM alpine:latest as builder

# 1.1 Install all build requirements
RUN apk update && apk upgrade && apk add --no-cache \
    clang-dev \
    llvm-dev \
    ncurses-dev \
    git \
    cargo \
    rust

WORKDIR /usr/src

# 1.2 Clone and build the Grin server
RUN git clone https://github.com/mimblewimble/grin.git --branch v2.0.0 \
    && cd grin \
    && cargo build --release

# 2. Runtime stage
FROM alpine:latest

RUN apk update && apk upgrade && apk add --no-cache ncurses libgcc bash

COPY --from=builder /usr/src/grin/target/release/grin /usr/local/bin/grin

WORKDIR /root/.grin

VOLUME ["/root/.grin"]

# Copy entry point file and set correct permissions
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
