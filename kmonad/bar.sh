#!/bin/sh

export KB_PATH="/dev/input/by-id/usb-foostan_Corne-event-kbd"
KBDCFG=$(envsubst < barconf.kbd)
sleep 1
kmonad <(echo "$KBDCFG") --log-level debug
