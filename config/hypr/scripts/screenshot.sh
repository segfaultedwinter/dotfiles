#!/bin/sh

OUTDIR="$(mktemp -d)"
FILE="$OUTDIR/$(date +%s)_ss"
#case "$1"
#    "-r" | "--region")

scale="$(hyprctl monitors -j | jq -r '[ .[] | select( .focused ) ].[].scale')"
dimensions="$(hyprctl monitors -j | jq -r '[ .[] | select( .focused ) ].[] | "\(.x),\(.y) \(.width / .scale)x\(.height / .scale)"')"
grim -g "$dimensions" - > "$FILE.png"
imv -f $FILE.png & sleep 1
dimensions="$(slurp | tr ',' '+')"
dimensions1="$(awk '{print $1}' <<< "$dimensions")"
dimensions1="$(awk -F "+" "{printf \"\%s+\%s\", \$1 / 1, \$2 / 1}" <<< "$dimensions1")"
dimensions2="$(awk 'print $2' <<< "$dimensions")"
dimensions2="$(awk -F "x" "{printf \"\%sx\%s\", \$1 / $scale, \$2 / $scale}" <<< "$dimensions2")"

convert $FILE.png -crop "$dimensions2+$dimensions1" $FILE.cut.png
cat $FILE.cut.png | wl-copy -t image/png
#esac
