#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.local/bin"
DEST="$DEST_DIR/macuninstall"

mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/macuninstall" "$DEST"
chmod +x "$DEST"

echo "Installed: $DEST"

case ":$PATH:" in
    *":$DEST_DIR:"*)
        echo "PATH: $DEST_DIR is already available."
        ;;
    *)
        echo
        echo "Add this to your shell configuration:"
        echo
        echo '  export PATH="$HOME/.local/bin:$PATH"'
        echo
        echo "For Zsh, usually: ~/.zshrc"
        ;;
esac

echo
echo "Verify with:"
echo "  macuninstall --version"
echo "  macuninstall --help"
