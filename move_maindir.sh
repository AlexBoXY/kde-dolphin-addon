#!/bin/bash
# Copyright (C) 2022  Alexander Boldt <alexboldt@yahoo.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Filetypes must be in file ~/.config/move_mainDir.conf  (one file type per line with wildcard '*' eg. *.txt ).
CONFIG="$HOME/.config/move_mainDir.conf"
dir="$1/"
count=0
ftypfile=""
while read -r ftypfile; do
    default+="$ftypfile "
done < "$CONFIG"
ftypinput=$(kdialog --title "Which file-types to move?" --inputbox "File-types to move:" "$default")
if [ $? = 0 ]; then
    for i in $ftypinput; do
        count=$((count + $(find "$dir" -mindepth 2 -name "*$i" -exec mv {} "$dir" \; -printf '.' | wc -c)))
    done
fi
notify-send.py "Finished moving $count files." \
                --app-name "move_mainDir" \
                --urgency low \
                --icon dialog-information

