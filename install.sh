#!/bin/bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="$HOME/.local/bin"
LIB_DIR="$HOME/.local/lib/ytfzf-prime"
SHARE_DIR="$HOME/.local/share/ytfzf-prime"
CONFIG_DIR="$HOME/.config/ytfzf-prime"

echo "==> Repository: $ROOT"

echo "==> Installing dependencies"
sudo pacman -S --needed \
    mpv \
    yt-dlp \
    jq \
    fzf \
    curl \
    chafa \
    python

echo "==> Creating directories"
mkdir -p \
    "$BIN_DIR" \
    "$LIB_DIR" \
    "$SHARE_DIR/addons" \
    "$CONFIG_DIR" \
    "$CONFIG_DIR/thumbnails"

echo "==> Installing ytfzf-prime"
curl -fsSL \
    https://raw.githubusercontent.com/tabletseeker/ytfzf/refs/heads/master/ytfzf \
    -o "$LIB_DIR/ytfzf"

chmod +x "$LIB_DIR/ytfzf"

echo "==> Installing addons"
rm -rf "$SHARE_DIR/addons"
mkdir -p "$SHARE_DIR/addons"

cp -a "$ROOT/ytfzf/addons/." \
      "$SHARE_DIR/addons/"

echo "==> Installing configuration without overwriting existing files"
cp -an "$ROOT/config/." "$CONFIG_DIR/"

touch "$CONFIG_DIR/subscriptions"

echo "==> Installing launcher"
install -Dm755 \
    "$ROOT/launch.sh" \
    "$BIN_DIR/ytfzf-prime"

echo
echo "Installation complete."
echo "Search:        ytfzf-prime \"linux\""
echo "Subscriptions: ytfzf-prime"
