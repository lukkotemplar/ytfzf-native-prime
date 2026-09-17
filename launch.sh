#!/bin/bash


YTFZF="$HOME/.local/lib/ytfzf-prime/ytfzf"

export YTFZF_CONFIG_DIR="$HOME/.config/ytfzf-prime"
export YTFZF_SYSTEM_ADDON_DIR="$HOME/.local/share/ytfzf-prime/addons"

case "${1:-}" in
    "")
        export invidious_instance="https://invidious.nerdvpn.de"

        exec "$YTFZF" \
            -c subs-ytdlp \
            -e smart-thumb-download \
            --fancy-subs \
            --pages=1 \
            --thumb-viewer=chafa-stable \
            --thumbnail-quality=medium \
            --preview-side=right \
            --sort-by=upload_date
        ;;

    *)
        export invidious_instance="https://invidious.flokinet.to"

        exec "$YTFZF" \
            -c search-ytdlp \
            -e smart-thumb-download \
            --thumb-viewer=chafa-stable \
            --preview-side=right \
            "$@"
        ;;
esac
