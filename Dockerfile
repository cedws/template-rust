FROM rust:1.99.1-alpine AS builder

RUN apk add --no-cache musl-dev

WORKDIR /src

COPY Cargo.toml Cargo.lock build.rs ./
COPY src ./src

ARG GIT_COMMIT=none
ARG SOURCE_DATE_EPOCH=
ENV GIT_COMMIT=${GIT_COMMIT} \
    SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}

RUN cargo build --release --locked

FROM cgr.dev/chainguard/static:latest

COPY --from=builder /src/target/release/template-rust /usr/local/bin/app

ENTRYPOINT ["/usr/local/bin/app"]
