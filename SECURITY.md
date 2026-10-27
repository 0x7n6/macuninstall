# Security and safety

`macuninstall` inspects and can move system-adjacent files, including launchd plists.

## Safety principles

- cleanup is interactive
- fuzzy matches are never auto-deleted
- `SAFE` items are moved to the Trash, not permanently erased
- BTM reset is never automatically executed
- package receipts are report-only
- Homebrew uninstall logic prefers Homebrew's own cask mechanism

## Reporting a safety issue

If you find a path that is incorrectly classified as `SAFE`, treat it as a high-priority bug.

A useful report includes:

- macOS version
- Intel or Apple Silicon
- `macuninstall --version`
- the relevant audit output
- the affected file path
- whether the referenced executable/app still exists

Do not publish sensitive local paths, usernames, or application data if they are not necessary to reproduce the issue.

## Recovery

Quarantined files are placed under:

```text
~/.Trash/MacUninstall-YYYYMMDD-HHMMSS/
```

Restore the relevant item before emptying the Trash if a cleanup action causes a regression.
