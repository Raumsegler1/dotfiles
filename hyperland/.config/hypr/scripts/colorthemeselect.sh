#!/usr/bin/env sh

# Set variables
ScrDir=`dirname "$(realpath "$0")"`
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/colorthemeselect.rasi"
themePath="${XDG_CONFIG_HOME:-$HOME/.config/wal/colorschemes/dark}"

# Get all the JSON files in the themePath
theme_files=$(find "$themePath" -type f -name "*.json")

# Function to extract colors from a JSON theme
get_colors_from_json() {
  jq -r '.colors | to_entries[] | .value' "$1"
}

# scale for monitor x res
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 17 / monitor_scale ))

# Nerd Font icon (replace with the icon you'd like to display)
nerd_icon="󰝤"  # Palette icon

# Rofi theme override
r_override="element{border-radius:10px;}
            listview{
            }
            element-text{
              font: \"JetBrainsMono Nerd Font 30\";
            }
            element-text{
              font: \"JetBrainsMono Nerd Font 30\";
            }"


RofiSel=$(find -L "$themePath" -type f -iname "*.json" | while read theme_file; do
  # Get colors from the JSON file
  colors=$(get_colors_from_json "$theme_file")
  
  # Iterate through colors and build the palette
  for color in $colors; do
    # Add the color and nerd icon without introducing new lines
    echo -en "<span foreground='$color'>$nerd_icon</span>"
  done
done | rofi -dmenu -markup-rows -theme-str "$r_override" -config "$RofiConf" -p "Choose Color:")

# If a selection is made, apply the corresponding theme
if [ ! -z "${RofiSel}" ]; then
  # Extract the selected theme name
  selected="${themePath}/${RofiSel}"
  
  # Apply the selected theme using pywal
  wal --theme "$selected"

  # Reload Waybar and Firefox to apply the new theme
  killall -SIGUSR2 waybar
  pywalfox update

  # Show notification
  dunstify "Changed Theme to $selected" -a "Theme" -r 91190 -t 3200
fi
