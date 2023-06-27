#! /bin/sh

setxkbmap -model pc104 -layout us,ru -variant ,, -option grp:alt_shift_toggle &

feh --bg-scale $HOME/.config/bspwm/wlppr.png &

xss-lock --transfer-sleep-lock -- $HOME/.config/bspwm/lock.sh &

picom &

sleep 3;

$HOME/.config/polybar/launch.sh &
