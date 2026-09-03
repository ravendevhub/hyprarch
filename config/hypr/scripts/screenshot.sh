#!/usr/bin/env bash

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
NAME="Screenshot_$(date '+%Y-%m-%d_%H.%M.%S').png"
FILE="$DIR/$NAME"

MODE="${1:-snip}"

case "$MODE" in
    full)
        grim "$FILE"
        ;;
    edit)
        GEOM=$(slurp)
        [ -z "$GEOM" ] && exit 0
        grim -g "$GEOM" - | swappy -f -
        exit 0
        ;;
    snip|*)
        GEOM=$(slurp)
        [ -z "$GEOM" ] && exit 0
        grim -g "$GEOM" "$FILE"
        ;;
esac

if [ -f "$FILE" ]; then
    wl-copy < "$FILE"
    notify-send -a "Screenshot" -i "$FILE" "Screenshot Captured" "Saved to ~/Pictures/Screenshots/$NAME and copied to clipboard."
fi
