#!/bin/bash

# Reload/Open eww
eww kill
eww daemon

# Day label at the top of the screen.
# eww open daybox

# Wofi button  -- Cancelled/still wip, I think it looks bad.
# eww open menu

# All other aesthetic gifs
# eww open gif1
# eww open gif2
# # eww open gif3

# The temperature widget
# eww open diinkitemperature


# Call the weather polling function once initially.
# I recommend installing cron and making a cronjob that calls
# the script with --getdata every 30 minutes.
WEATHER_POLLING="$HOME/.config/eww/scripts/weather.sh"
bash "$WEATHER_POLLING" --getdata &
disown

# -- Experimental gif, uncomment if you want it :D
# eww open gif3
