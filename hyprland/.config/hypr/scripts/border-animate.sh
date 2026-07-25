#!/bin/bash
colors=(
    "rgba(000000ee) rgba(111111ee)"
    "rgba(111111ee) rgba(222222ee)"
    "rgba(222222ee) rgba(333333ee)"
    "rgba(333333ee) rgba(000000ee)"
)

i=0
while true; do
    hyprctl keyword general:col.active_border "${colors[$i]} 45deg"
    i=$(( (i + 1) % ${#colors[@]} ))
    sleep 2
done
