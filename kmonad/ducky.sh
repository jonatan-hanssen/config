#!/bin/sh

export KB_PATH="/dev/input/by-id/usb-Ducky_Ducky_One_3_SF_RGB_DK-V1.07-220107-if01-event-kbd"
KBDCFG=$(envsubst < conf.kbd)
sleep 1
kmonad <(echo "$KBDCFG") --log-level debug
