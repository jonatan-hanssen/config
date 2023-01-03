#!/bin/sh

export KB_PATH="/dev/input/by-path/platform-i8042-serio-0-event-kbd"
KBDCFG=$(envsubst < conf.kbd)
sleep 1
kmonad <(echo "$KBDCFG") --log-level debug
