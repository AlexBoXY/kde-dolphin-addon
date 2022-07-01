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
# Passwords must be in file ~/.config/archiv_extract.pass  (one password per line)
# (
PASSWORDS="$HOME/.config/archiv_extract.pass"
CONFIG="$HOME/.config/archiv_extract.conf"
read -r defdir<"$CONFIG"
cnt=0
failc=0
failf=""
msgid=123
status="none"
if  dir=$(kdialog --getexistingdirectory "$defdir"); then
	for i in "$@"; do
# echo "$i"
		(( cnt++ )) || true
		dunstify -r $msgid -a "Extract w PW" -u low -i dialog-information "$cnt of $# files.
Next: $i"
		status="fail"
		while read -r pass; do
			if [[ "$i" == *".rar" ]]; then
				unrar -y -p"$pass" x "$i" "$dir"
				rc=$?
			else
				7z -y -p"$pass" -o"$dir" x "$i"
				rc=$?
			fi
			if [[ $rc != 0 ]]; then
				status="fail"
				dunstify -a "Extract w PW" -u low -i dialog-information  "Failed $i with PW: $pass"
			else
				status="success"
				break
			fi
		done <"$PASSWORDS"
		if [[ $status = "fail" ]]; then
            failf+="$i "
            (( failc++ )) || true
		fi
	done
fi
dunstify -c $msgid
if [[ $status = "none" ]]; then
    dunstify -a "Extract w PW" -u low -i dialog-information "Canceled"
else
    dunstify -a "Extract w PW" -u low -i dialog-information "Finished extraction of $cnt files. Failed: $failc"
fi
# ) 2>&1 | tee -a /home/alexander/test.log
