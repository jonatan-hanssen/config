#!/bin/sh

dir="/home/jona/.config/alacritty/"

if cmp -s $dir/onehalflight.yml $dir/theme.yml; then
    cp $dir/onehalfdark.yml $dir/theme.yml
else
    cp $dir/onehalflight.yml $dir/theme.yml
fi

touch $dir/alacritty.yml
