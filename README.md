# template-rust

A small starting point for Rust CLI projects, with the usual repo furniture already wired up:

- **Formatting and linting** — `rustfmt` config, Clippy lints in `Cargo.toml`, both enforced in CI
- **Cross-platform releases** — [cargo-dist](https://axodotdev.github.io/cargo-dist/) builds Linux, macOS, and Windows archives, checksums, and shell/PowerShell installers on every tag
- **Container image** — multi-stage Dockerfile plus a workflow that publishes multi-arch images to GHCR
- **Maintenance** — Dependabot for Cargo, GitHub Actions, and Docker base images

## Requirements

- Rust via [rustup](https://rustup.rs) (the pinned version is in `rust-toolchain.toml`)
- [just](https://github.com/casey/just) (optional, for the recipes)
- Docker (optional, for the image)
- [cargo-dist](https://axodotdev.github.io/cargo-dist/) (only needed for release work; installs the `dist` CLI)

## Quick start

```sh
cargo run
# version 0.1.0, commit 123456789abc, built at 2026-10-25T10:00:00Z

just check   # fmt + clippy + tests
```

## Recipes

| Command            | What it does                                      |
| ------------------ | ------------------------------------------------- |
| `just`             | List the available recipes                        |
| `just fmt`         | Format the code                                   |
| `just fmt-check`   | Check formatting without touching files           |
| `just lint`        | Run Clippy with warnings as errors                |
| `just test`        | Run the test suite                                |
| `just check`       | Run everything CI runs                            |
| `just build`       | Build a release binary for the current platform   |
| `just release-check` | Dry-run the cargo-dist release plan             |

## Layout

```text
src/main.rs                   binary entrypoint
build.rs                      embeds git commit and build date
Cargo.toml                    package, release profile, lints, cargo-dist opt-in
dist-workspace.toml           cargo-dist configuration
Dockerfile                    musl build + Chainguard static runtime image
rust-toolchain.toml           pinned Rust toolchain
rustfmt.toml                  formatter settings
justfile                      local task shortcuts
.github/workflows/build.yml   fmt, clippy, tests, Docker build check
.github/workflows/release.yml cargo-dist release pipeline (generated)
.github/workflows/docker.yml  GHCR image publishing
```

## Releasing

1. Bump `version` in `Cargo.toml`.
2. Commit and push a tag:

   ```sh
   git tag v0.1.0
   git push origin v0.1.0
   ```

The release workflow builds these targets and creates a GitHub Release:

- `aarch64-apple-darwin`, `x86_64-apple-darwin`
- `aarch64-unknown-linux-gnu`, `x86_64-unknown-linux-gnu`
- `x86_64-pc-windows-msvc`

It also attaches checksums and shell/PowerShell installer scripts. No repository secrets are required — the workflow uses `GITHUB_TOKEN`.

The Docker workflow publishes `ghcr.io/<owner>/<repo>` for `linux/amd64` and `linux/arm64`, tagged with the semantic version, major/minor, major, and `latest`, with provenance and an SBOM.

`release.yml` is generated — edit `dist-workspace.toml` and run `dist generate` instead of editing the workflow by hand.

### Optional: Homebrew

cargo-dist can also publish a Homebrew formula. Add to `dist-workspace.toml`:

```toml
tap = "your-username/homebrew-tap"
publish-jobs = ["homebrew"]
```

Then regenerate and provide a `HOMEBREW_TAP_TOKEN` secret with access to the tap repo.

## Docker

```sh
docker build -t template-rust .
docker run --rm template-rust
```

The build is static (musl), and the runtime image is [`cgr.dev/chainguard/static`](https://images.chainguard.dev/directory/image/static/overview). Pass `GIT_COMMIT` and `SOURCE_DATE_EPOCH` as build args to stamp reproducible metadata.

## Using this template

1. Rename the package in `Cargo.toml` (and the binary path in `Dockerfile` if you do).
2. Update `repository` in `Cargo.toml` and the image references in the README.
3. Adjust `targets` or `installers` in `dist-workspace.toml`, then run `dist generate`.
4. Add a `LICENSE` file (none is included so you can choose).
