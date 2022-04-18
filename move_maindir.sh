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
dir="$1/"
ext=$(kdialog --checklist "Select File-Extension(s):" 1 "*.mkv" on 2 "*.avi" off 3 "*.mp4" off)
rcExt=$?
if [[ $rcExt == 0 ]]; then
	for i in $ext; do
		case $i in
			'"1"' )
                find $dir -mindepth 2 -name '*.mkv' -exec mv {} $dir \; -exec kdialog --passivepopup {} \;
                ;;
			'"2"' )
                find $dir -mindepth 2 -name '*.avi' -exec mv {} $dir \; -exec kdialog --passivepopup {} \;
                ;;
			'"3"' )
                find $dir -mindepth 2 -name '*.mp4' -exec mv {} $dir \; -exec kdialog --passivepopup {} \;
                ;;
		esac
	done
fi
kdialog --passivepopup "Finished Move MainDir"

