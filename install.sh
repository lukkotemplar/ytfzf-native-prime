#!/bin/bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="$HOME/.local/bin"
LIB_DIR="$HOME/.local/lib/ytfzf-prime"
SHARE_DIR="$HOME/.local/share/ytfzf-prime"
CONFIG_DIR="$HOME/.config/ytfzf-prime"

echo "==> Repository: $ROOT"

echo "==> Detecting package manager"

if command -v pacman >/dev/null 2>&1; then
    DISTRO="Arch-based"
    PKG_MANAGER="pacman"

elif command -v apt >/dev/null 2>&1; then
    DISTRO="Debian-based"
    PKG_MANAGER="apt"

else
    DISTRO="unknown"
    PKG_MANAGER=""
fi

echo "==> System: $DISTRO"

echo "==> Checking dependencies"
DEPS=(
    mpv
    yt-dlp
    jq
    fzf
    curl
    chafa
)

MISSING=()

for dep in "${DEPS[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING+=("$dep")
    fi
done

if ! command -v python3 >/dev/null 2>&1 &&
   ! command -v python >/dev/null 2>&1; then
    MISSING+=("python")
fi

if ((${#MISSING[@]} == 0)); then
    echo "==> All dependencies are installed"

elif [[ "$PKG_MANAGER" == "pacman" ]]; then
    echo "==> Missing dependencies: ${MISSING[*]}"

    PACKAGES=()

    for dep in "${MISSING[@]}"; do
        case "$dep" in
            python)
                PACKAGES+=("python")
                ;;
            *)
                PACKAGES+=("$dep")
                ;;
        esac
    done

    echo "==> Installing dependencies with pacman"
    sudo pacman -S --needed "${PACKAGES[@]}"

elif [[ "$PKG_MANAGER" == "apt" ]]; then
    echo "==> Missing dependencies: ${MISSING[*]}"

    PACKAGES=()

    for dep in "${MISSING[@]}"; do
        case "$dep" in
            python)
                PACKAGES+=("python3")
                ;;
            *)
                PACKAGES+=("$dep")
                ;;
        esac
    done

    echo "==> Installing dependencies with apt"
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}"

else
    echo "Please install the following dependencies manually:"
    printf '  %s\n' "${MISSING[@]}"
    echo
    exit 1
fi

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
