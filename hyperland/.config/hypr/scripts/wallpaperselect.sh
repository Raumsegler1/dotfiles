#!/usr/bin/env sh

# set variables
ScrDir=`dirname "$(realpath "$0")"`
RofiConf="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/wallpaperselect.rasi"
#wallPath="${XDG_CONFIG_HOME:-$HOME/.config}/swww"
wallPath="${XDG_CONFIG_HOME:-$HOME/dotfiles/wallpapers}"

# scale for monitor x res
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_monres=$(( x_monres * 17 / monitor_scale ))

# set rofi override
#elem_border=$(( hypr_border * 3 ))
#${elem_border}
r_override="element{border-radius:10px; }
            listview{
              columns:20;
              gap:60px; /* Spacing between list items */
              align-items: center; /* Aligns items vertically in the center */
            }
            element{
              padding:0px;
              orientation:vertical;
              border-radius:8px;
             width:200px; /*Set width if necessary to ensure even alignment */
            }
            element-icon{
              size:${x_monres}px;
              border-radius:0px;
            }
            element-text{
              padding:20px;
            }"

# launch rofi menu
RofiSel=$( find -L "${wallPath}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -exec basename {} \; | sort | while read rfile
do
  echo -en "$rfile\x00icon\x1f${wallPath}/${rfile}\n"
done | rofi -dmenu -theme-str "${r_override}" -config "${RofiConf}" -select "${currentWall}")

# apply wallpaper
if [ ! -z "${RofiSel}" ] ; then
  selected="${wallPath}/${RofiSel}"

  swww img $selected --transition-type "grow" --transition-pos 'top-right' --transition-duration 2 --transition-fps 30 --transition-bezier .64,.11,.49,1.01
  rm "${wallPath}/current.set"

  sleep 3s
  ln -s $selected "${wallPath}/current.set"

# Set wallpaper using wal
  wal -i ~/dotfiles/wallpapers/current.set -n

# reload Waybar process
  killall -SIGUSR2 waybar

# reload Firefox
  pywalfox update

  pywal-spicetify Sleek
  
  dunstify "Changed Wallpaper to ${RofiSel}" -a "Wallpaper" -i "${wallPath}/${RofiSel}" -r 91190 -t 2200
fi
