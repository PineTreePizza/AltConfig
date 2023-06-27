#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Function to check if a monitor is eDP
is_edp() {
  xrandr --query | grep "^$1" | grep " connected" | grep "eDP" >/dev/null
}

# Launch Polybar for each connected monitor
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if is_edp $m; then
      # Load different config for eDP monitor
			MONITOR=$m polybar -r main &
			MONITOR=$m polybar -r left &
			MONITOR=$m polybar -r right &
			MONITOR=$m polybar -r center &
    else
      # Load different config for non-eDP monitors
			MONITOR=$m polybar -r main &
			MONITOR=$m polybar -r hdmi_left &
			MONITOR=$m polybar -r hdmi_right &
			MONITOR=$m polybar -r hdmi_center &
    fi
  done
else
  polybar -r main &
  polybar -r left &
  polybar -r right &
  polybar -r center &
fi

echo "Polybar launched..."
