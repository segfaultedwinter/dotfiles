#!/bin/sh
brightnessctl set $1
if [ "$(brightnessctl get)" == "0" ] && [ ! "$2" == "1" ] ; then
    brightnessctl set 1
fi
