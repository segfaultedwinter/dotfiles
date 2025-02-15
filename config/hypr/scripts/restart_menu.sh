#!/bin/sh

restart=""

if [ ! "$1" ] ; then
    restart="$(printf "easyeffects\nwaybar\nmako" | bemenu --prompt restart)"
fi

case "$restart" in
    "easyeffects")
        ~/.config/hypr/scripts/restart.sh easyeffects --gapplication-service
        ;;

    "waybar")
        ~/.config/hypr/scripts/restart.sh waybar -c ~/.config/hypr/waybar.conf -s ~/.config/hypr/waybar.css
        ;;

    "mako")
        ~/.config/hypr/scripts/restart.sh mako
        ;;

    *)
        ~/.config/hypr/scripts/restart.sh $restart
        ;;
esac
