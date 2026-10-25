default:
    @just --list

# Format the code
fmt:
    cargo fmt --all

# Check formatting without modifying files
fmt-check:
    cargo fmt --all -- --check

# Run Clippy with warnings treated as errors
lint:
    cargo clippy --all-targets --all-features --locked -- -D warnings

# Run the test suite
test:
    cargo test --all-targets --all-features --locked

# Run everything CI runs
check: fmt-check lint test

# Build a release binary for the current platform
build:
    cargo build --release --locked

# Dry-run the release plan (requires the cargo-dist `dist` CLI)
release-check:
    dist plan
