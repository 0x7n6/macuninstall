# macuninstall

A conservative, evidence-based macOS app uninstaller and orphan auditor for the command line.

`macuninstall` is built for people who are tired of deleting an app and later finding stale LaunchAgents, LaunchDaemons, preferences, caches, Homebrew state, or Background Task Management records still hanging around.

Instead of blindly deleting anything that "looks old", `macuninstall` separates findings by confidence and asks before making changes.

> **Status:** public preview (`v0.4.2`). Tested on Apple Silicon macOS. Please review findings before confirming any cleanup.

## Why this exists

On macOS, removing `Foo.app` does not necessarily remove everything associated with it. Apps may leave behind:

- `~/Library/Preferences`
- `~/Library/Caches`
- `~/Library/Application Support`
- `~/Library/Saved Application State`
- `~/Library/HTTPStorages`
- `~/Library/WebKit`
- `~/Library/Containers`
- `~/Library/LaunchAgents`
- `/Library/LaunchAgents`
- `/Library/LaunchDaemons`
- `/Library/PrivilegedHelperTools`
- package receipts
- Homebrew cask state
- Background Task Management (BTM) registrations

Third-party cleaners can remove many of these, but BTM is managed by macOS and does not expose a documented per-entry removal command to end users.

`macuninstall` therefore takes a conservative approach: prove what it can, report what it cannot safely remove, and avoid destructive guesses.

## Features

### Full orphan audit

Run without arguments:

```bash
macuninstall
```

The audit checks:

- installed `.app` bundles in `/Applications` and `~/Applications`
- stale `LaunchAgents` and `LaunchDaemons`
- macOS Background Task Management records via `sfltool dumpbtm`
- Homebrew `autoremove --dry-run`
- Homebrew `cleanup --dry-run`
- Homebrew casks whose `.app` artifact is missing
- a local application snapshot, so later runs can notice apps that disappeared since the previous scan

### Targeted uninstall

```bash
macuninstall "/Applications/Foo.app"
```

The tool reads the app's bundle metadata and looks for related files such as preferences, caches, saved state, support data, launchd entries, helper tools, package receipts, and Homebrew ownership.

If the app is managed by Homebrew Cask, `macuninstall` prefers:

```bash
brew uninstall --cask --zap <cask>
```

over manually deleting files.

### Confidence classes

Audit results are intentionally separated:

```text
SAFE
```

High-confidence orphan files that can be quarantined automatically, such as a launchd plist whose absolute executable path no longer exists.

```text
REVIEW
```

Evidence exists, but the tool does not consider it safe enough for automatic deletion.

```text
BTM-ONLY
```

A Background Task Management record appears stale, but `macuninstall` only reports it. It never automatically resets the BTM database.

### Trash-based quarantine

Files classified as `SAFE` are not permanently erased. When confirmed, they are moved into:

```text
~/.Trash/MacUninstall-YYYYMMDD-HHMMSS/
```

This makes accidental cleanup recoverable until the Trash is emptied.

### Homebrew awareness

The full audit includes:

```bash
brew autoremove --dry-run
brew cleanup --dry-run
```

It can also identify a cask that Homebrew still considers installed while its `.app` artifact has been manually removed.

For those cases, it can offer:

```bash
brew uninstall --cask --zap --force <cask>
```

## Requirements

- macOS
- Bash 3.2 or newer
- standard macOS command-line tools
- optional: Homebrew

The script intentionally remains compatible with the Bash version included with macOS.

## Installation

### Option 1: installer

Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/macuninstall.git
cd macuninstall
./install.sh
```

The installer copies the executable to:

```text
~/.local/bin/macuninstall
```

If `~/.local/bin` is not in your `PATH`, add this to your shell configuration:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

For Zsh, that normally means `~/.zshrc`.

Reload your shell:

```bash
source ~/.zshrc
rehash
```

Verify:

```bash
macuninstall --version
macuninstall --help
```

### Option 2: manual install

```bash
mkdir -p ~/.local/bin
cp macuninstall ~/.local/bin/macuninstall
chmod +x ~/.local/bin/macuninstall
```

## Usage

### Audit the Mac

```bash
macuninstall
```

or:

```bash
macuninstall --audit
```

A typical clean result looks like:

```text
=== SAFE: can be quarantined automatically ===
  none

=== REVIEW: evidence found, never auto-delete ===
  none

=== BTM-ONLY: macOS registry stale, report only ===
  none
```

The action menu then offers:

```text
1  quarantine SAFE orphan files
2  Homebrew cleanup/autoremove + stale-cask offers
3  both 1 and 2
4  print optional global BTM reset command
q  quit
```

Option `4` only **prints**:

```bash
sudo sfltool resetbtm
sudo reboot
```

It does not execute those commands.

### Targeted app uninstall

```bash
macuninstall "/Applications/Foo.app"
```

Always quote paths that may contain spaces.

### Homebrew-only maintenance

```bash
macuninstall --brew
```

### Refresh the application baseline

```bash
macuninstall --snapshot
```

The snapshot is stored at:

```text
~/.local/state/macuninstall/apps.tsv
```

## How the snapshot helps

A cleaner cannot safely infer the owner of every random directory under `~/Library`.

To reduce guessing, `macuninstall` remembers installed applications.

For example:

```text
previous run:
com.vendor.foo    Foo    /Applications/Foo.app

current run:
Foo.app is gone
```

The next audit can then report that the app disappeared and look for exact bundle-ID-related residue.

The first run creates the baseline. The feature becomes more useful over time.

## Background Task Management

`macuninstall` inspects BTM with:

```bash
sfltool dumpbtm
```

Some macOS BTM output may represent a user's home path using the numeric UID, for example:

```text
/Users/503/Applications/Filee.app
```

while the actual home directory may be:

```text
/Users/alice
```

The scanner normalizes that representation before deciding whether a path is missing. This prevents valid apps from being incorrectly reported as stale.

`macuninstall` never automatically runs:

```bash
sudo sfltool resetbtm
```

because it resets the BTM database globally rather than deleting one targeted entry.

## Safety model

This project is intentionally biased toward false negatives rather than dangerous false positives.

It follows these rules:

1. Audit first.
2. Prefer exact identifiers and absolute paths.
3. Do not automatically delete fuzzy name matches.
4. Prefer a vendor or Homebrew uninstaller when one is known.
5. Quarantine `SAFE` files to the Trash rather than permanently deleting them.
6. Never automatically reset the macOS Background Task Management database.
7. Treat package receipts as report-only.
8. Make the user confirm destructive actions.

Still, this is system-cleanup software. Read the proposed actions before confirming them.

## Known limitations

- It cannot prove that every old file under `~/Library` is an orphan.
- Apps removed before the first snapshot may have leftovers with no remaining metadata that links them to the original app.
- Some apps use proprietary uninstallers, system extensions, network extensions, drivers, or installer frameworks that require vendor-specific removal steps.
- Shared support directories may be used by multiple applications.
- BTM currently has no documented targeted end-user removal command in this tool's workflow.
- Homebrew artifact parsing depends on Homebrew's human-readable `brew info --cask` output.
- The current release has primarily been exercised on Apple Silicon macOS and should be considered a preview.

If `macuninstall` cannot establish enough evidence, it should report or skip the item rather than guess.

## Uninstall macuninstall

From the cloned repository:

```bash
./uninstall.sh
```

Or manually:

```bash
rm -f ~/.local/bin/macuninstall
rm -rf ~/.local/state/macuninstall
```

The state directory only contains `macuninstall`'s own local snapshot.

## Development

Validate shell syntax with the macOS system Bash:

```bash
/bin/bash -n macuninstall
```

Run the smoke test:

```bash
./tests/smoke.sh
```

Useful test cases include:

- a clean Mac with no orphan launchd entries
- an intentionally broken LaunchAgent pointing to a missing executable
- a Homebrew cask whose app bundle was manually removed
- a user whose short username differs from the numeric UID used in BTM output
- an app installed under `~/Applications`
- paths containing spaces

Contributions that improve evidence quality and reduce false positives are preferred over aggressive cleanup heuristics.

## Project philosophy

The goal is not to claim:

> "Your Mac is 100% clean."

That cannot be proven reliably from filenames alone.

The goal is to answer a narrower, safer question:

> "What can we show evidence is orphaned, what merely deserves review, and what belongs to macOS state that should not be touched automatically?"

## AI assistance disclosure

This project was designed, debugged, and documented through human-directed collaboration with ChatGPT by OpenAI. AI assistance was used to help reason about macOS cleanup behavior, draft and revise shell code, investigate bugs, and prepare documentation. The project owner directed the requirements, tested the tool on real hardware, identified failures, validated fixes, and retains responsibility for reviewing and maintaining the published code.

AI assistance does not imply endorsement, warranty, or affiliation by OpenAI.
