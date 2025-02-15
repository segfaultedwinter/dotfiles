#!/bin/sh
exec $HOME/.config/hypr/scripts/$(ls $HOME/.config/hypr/scripts/ | grep -v global_menu.sh | sort | bemenu --prompt "select script ->")
