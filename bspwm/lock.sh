#!/bin/sh

BLANK='#2b2f32'
CLEAR='#9096cf22'
DEFAULT='#505050'
TEXT='#42A5F5'
WRONG='#EC407A'
VERIFYING='#42A5F5'
NONE='#00000000'

i3lock \
    --insidever-color=$CLEAR     \
    --ringver-color=$VERIFYING   \
    \
    --insidewrong-color=$CLEAR   \
    --ringwrong-color=$WRONG     \
    \
    --inside-color=$BLANK        \
    --ring-color=$DEFAULT        \
    --line-color=$NONE          \
    --separator-color=$DEFAULT   \
    \
    --verif-color=$TEXT          \
    --wrong-color=$TEXT          \
    --keyhl-color=$WRONG         \
    --bshl-color=$WRONG          \
    \
    --screen 0                   \
    --radius 150 \
    --ring-width 75 \
    --indicator                        \
		--tiling \
    --ind-pos="1920/2:1080/4"  \
    --verif-text=""\
    --wrong-text=""\
    -i $HOME/.config/bspwm/Lock.png\
