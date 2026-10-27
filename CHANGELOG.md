# Changelog

All notable changes to this project will be documented here.

## 0.4.2

Initial public preview.

### Added

- evidence-based full-system orphan audit
- targeted `.app` uninstall mode
- launchd orphan detection
- macOS Background Task Management inspection
- BTM numeric-UID home path normalization
- local installed-app snapshot
- Homebrew `autoremove --dry-run`
- Homebrew `cleanup --dry-run`
- missing Homebrew cask app detection
- Trash-based quarantine for high-confidence orphan files
- explicit `SAFE`, `REVIEW`, and `BTM-ONLY` result classes
- optional display of the global BTM reset commands without executing them

### Fixed

- BSD `awk` compatibility on macOS
- Bash 3.2 empty-array behavior with `nounset`
- false-positive BTM findings caused by `/Users/<numeric-uid>/...` paths
