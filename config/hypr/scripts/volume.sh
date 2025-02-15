#!/bin/bash
volume="+5"
if [ $1 ] && [ $2 ] ; then
    volume="$1$2"
elif [ $1 ] ; then
    volume="$15"
fi
pactl set-sink-volume @DEFAULT_SINK@ $volume%
vol="$(pactl get-sink-volume @DEFAULT_SINK@ | grep -m1 -Eo '[0-9]?[0-9]?[0-9]%' | head -n1 | tr -d %)"
if (( "$vol" > "100" )); then
    notify-send "Warning loud volume ($vol)"
fi
if (( "$vol" >= "150" )); then
    pactl set-sink-volume @DEFAULT_SINK@ 150%
    notify-send "Max volume (150)"
fi
