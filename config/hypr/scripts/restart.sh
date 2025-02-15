#!/bin/sh
killall -9 $1
sleep 1
$@ & disown
exit 0
