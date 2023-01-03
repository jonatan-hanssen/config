#!/bin/sh

export KB_PATH="/dev/input/by-id/usb-04d9_USB-HID_Keyboard-event-kbd"
KBDCFG=$(envsubst < barconf.kbd)
sleep 1
kmonad <(echo "$KBDCFG") --log-level debug
