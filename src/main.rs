//! A minimal CLI that reports the version it was built from.

const VERSION: &str = env!("CARGO_PKG_VERSION");
const COMMIT: &str = env!("GIT_COMMIT");
const BUILD_DATE: &str = env!("BUILD_DATE");

fn version_line() -> String {
    format!("version {VERSION}, commit {COMMIT}, built at {BUILD_DATE}")
}

fn main() {
    println!("{}", version_line());
}

#[cfg(test)]
mod tests {
    use super::{BUILD_DATE, COMMIT, VERSION, version_line};

    #[test]
    fn version_line_includes_build_metadata() {
        let line = version_line();
        assert!(line.contains(VERSION));
        assert!(line.contains(COMMIT));
        assert!(line.contains(BUILD_DATE));
    }
}
