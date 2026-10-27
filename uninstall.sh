#!/bin/bash
set -e

BIN="$HOME/.local/bin/macuninstall"
STATE="$HOME/.local/state/macuninstall"

echo "This will remove:"
echo "  $BIN"
echo "  $STATE"
echo
printf "Continue? [y/N] "
read -r answer

case "$answer" in
    y|Y|yes|YES)
        rm -f "$BIN"
        rm -rf "$STATE"
        echo "macuninstall removed."
        ;;
    *)
        echo "No changes made."
        ;;
esac
