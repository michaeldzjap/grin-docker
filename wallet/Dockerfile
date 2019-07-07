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

# 1.2 Clone and build the Grin wallet
RUN git clone https://github.com/mimblewimble/grin-wallet.git --branch v2.0.0 \
    && sed -i -e 's/format!("127.0.0.1:{}", self.owner_api_listen_port())/format!("0.0.0.0:{}", self.owner_api_listen_port())/' /usr/src/grin-wallet/config/src/types.rs \
    && cd grin-wallet \
    && cargo build --release

# 2. Runtime stage
FROM alpine:latest

RUN apk update && apk upgrade \
    && apk add --no-cache ncurses libgcc expect curl supervisor

COPY --from=builder /usr/src/grin-wallet/target/release/grin-wallet /usr/local/bin/grin-wallet

WORKDIR /root/.grin

VOLUME ["/root/.grin"]

# Copy entry point file and set correct permissions
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT ["entrypoint.sh"]
