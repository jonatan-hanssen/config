#!/bin/sh

if cmp -s onehalflight.yml theme.yml; then
    cp onehalfdark.yml theme.yml
else
    cp onehalflight.yml theme.yml
fi

touch alacritty.yml
