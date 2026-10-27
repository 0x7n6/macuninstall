#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "== syntax =="
/bin/bash -n "$ROOT/macuninstall"

echo "== version =="
version="$("$ROOT/macuninstall" --version)"
test "$version" = "0.4.2"

echo "== help =="
"$ROOT/macuninstall" --help | grep -q "Full orphan/junk audit."

echo "Smoke test passed."
