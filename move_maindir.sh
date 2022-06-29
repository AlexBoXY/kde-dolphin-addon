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
#ext=$(kdialog --checklist "Select File-Extension(s):" 1 "*.mkv" on 2 "*.avi" off 3 "*.mp4" off)
rcExt=$?
count=0
if [[ $rcExt == 0 ]]; then
#	for i in $ext; do
    while read -r ftyp; do
#		case $i in
#		*1* )
echo $ftyp
			count=$(expr $count + $(find $dir -mindepth 2 -name $ftyp -exec mv {} $dir \; -printf '.' | wc -c))
#			;;
#		*2* )
#			count=$(expr $count + $(find $dir -mindepth 2 -name '*.avi' -exec mv {} $dir \; -printf '.' | wc -c))
#			;;
#		*3* )
#			count=$(expr $count + $(find $dir -mindepth 2 -name '*.mp4' -exec mv {} $dir \;  -printf '.' | wc -c))
#			;;
#		esac
	done < $CONFIG
fi
dunstify -a "move_mainDir" -u low -i dialog-information "Finished moving $count files."

