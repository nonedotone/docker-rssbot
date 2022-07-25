# Build
FROM ekidd/rust-musl-builder AS builder

ARG VERSION=6c1e5f1

RUN git clone https://github.com/iovxw/rssbot.git . && \
    sudo chown -R rust:rust /home/rust && sudo chown -R rust:rust /opt/rust/rustup && \
    rustup toolchain install nightly && rustup default nightly && \
    rustup target add x86_64-unknown-linux-musl && \
    git checkout ${VERSION} && cargo build --release


# Run
FROM alpine:3.16
LABEL name="none" email="none@none.one"

COPY --from=builder /home/rust/src/target/x86_64-unknown-linux-musl/release/rssbot /usr/bin/rssbot

ENTRYPOINT ["/usr/bin/rssbot"]