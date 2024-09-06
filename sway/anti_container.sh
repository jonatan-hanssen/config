#!/bin/sh
swaymsg mark a
swaymsg '[con_mark="a"]' move scratchpad
swaymsg mark b
swaymsg '[con_mark="b"]' move scratchpad
swaymsg '[con_mark="a"]' move container to workspace current
swaymsg '[con_mark="a"]' floating toggle
swaymsg '[con_mark="b"]' move container to workspace current
swaymsg '[con_mark="b"]' floating toggle
swaymsg '[con_mark="a"]' focus
