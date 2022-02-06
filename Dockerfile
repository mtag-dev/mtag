FROM openresty/openresty:bionic AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG LUAROCKS_VERSION=3.7.0

# Installing Squall-Router
RUN apt update
RUN apt install -y unzip curl make build-essential
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -L -O https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz
RUN tar xpf luarocks-${LUAROCKS_VERSION}.tar.gz && cd luarocks-${LUAROCKS_VERSION} && ./configure && make && make install
RUN PATH="$HOME/.cargo/bin:$PATH" luarocks install squall-router

# Installing opm dependencies
RUN opm install zmartzone/lua-resty-openidc
RUN opm install lua-resty-http
RUN opm install lua-resty-session
RUN opm install lua-resty-jwt
RUN opm install lua-resty-websocket

FROM openresty/openresty:bionic
COPY --from=builder /usr/local/lib/luarocks/rocks-5.1 /usr/local/lib/luarocks/rocks-5.1
COPY --from=builder /usr/local/lib/lua/5.1 /usr/local/lib/lua/5.1
COPY --from=builder /usr/local/openresty/site /usr/local/openresty/site
