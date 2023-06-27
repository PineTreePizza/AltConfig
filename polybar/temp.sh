#!/bin/bash

temp=$(sensors | grep "Tctl" | awk '{print $2}')

yad --title="CPU Temperature" --text="$temp" --class="COOL" --width=200 --height=100 --no-buttons --on-top &

# Retrieve the window ID of the Yad window
window_id=$(xdo id -N "COOL")

# Set the window's BSPWM properties to make it floating
bspc rule -a COOL state=floating

eval "$(xdotool getmouselocation --shell)"

xdotool windowmove $window_id $X $Y
