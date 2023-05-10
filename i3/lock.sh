#!/bin/sh

BLANK='#2b2f32'
CLEAR='#9096cf22'
DEFAULT='#707880'
TEXT='#749ef0'
WRONG='#e4b3eb'
VERIFYING='#90c6cf'
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
    --ind-pos="1920/2:1080/4"  \
    --verif-text=""\
    --wrong-text=""\
    -i $HOME/.config/i3/Lock.png\
