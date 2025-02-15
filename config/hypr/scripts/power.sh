#!/bin/sh

profile="$1"
current="$(powerprofilesctl get)"
if [ ! "$profile" ] ; then
    profile="$(printf "performance\nbalanced\npower-saver" | grep -v "$current" | bemenu --prompt "$current ->")"
fi
cmd="powerprofilesctl set $profile"
$cmd
current="$(powerprofilesctl get)"
if [ ! "$?" == "0" ] ; then
    notify-send "Error running '$cmd'!"
elif [ "$profile" == "$current" ] ; then
    notify-send "Power profile succsessfully set to '$(powerprofilesctl get)'!"
else
    notify-send "Power profile is set to '$(powerprofilesctl get)'!"
fi
