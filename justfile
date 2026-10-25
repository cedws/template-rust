default:
    @just --list

fmt:
    cargo fmt --all

fmt-check:
    cargo fmt --all -- --check

lint:
    cargo clippy --all-targets --all-features --locked -- -D warnings

test:
    cargo test --all-targets --all-features --locked

check: fmt-check lint test

build:
    cargo build --release --locked

release-check:
    dist plan
