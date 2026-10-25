# syntax=docker/dockerfile:1

FROM rust:1.99.1-alpine AS builder

# Alpine package versions move with the base image; pinning them here would break on every bump.
# hadolint ignore=DL3018
RUN apk add --no-cache musl-dev

WORKDIR /src

COPY Cargo.toml Cargo.lock build.rs ./
COPY src ./src

# Passed by CI so the image reports the commit it was built from.
ARG GIT_COMMIT=none
ARG SOURCE_DATE_EPOCH=
ENV GIT_COMMIT=${GIT_COMMIT} \
    SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}

# Alpine's Rust target links against musl statically.
RUN cargo build --release --locked

# Runtime image pinned by digest; Dependabot keeps it up to date.
FROM cgr.dev/chainguard/static@sha256:c12f0107f8afb0bbc1b0eff96ff8675e85a10c6083d039b777c51fef5c27420f

COPY --from=builder /src/target/release/template-rust /usr/local/bin/app

ENTRYPOINT ["/usr/local/bin/app"]
