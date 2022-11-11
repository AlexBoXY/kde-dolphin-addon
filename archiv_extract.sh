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
msgid=$(($RANDOM))
status="none"
if  dir=$(kdialog --getexistingdirectory "$defdir"); then
	for i in "$@"; do
# echo "$i"
		(( cnt++ )) || true
		ACTION=$(dunstify --replace=$msgid --appname="Extract w PW" --icon=dialog-information --action="cancelAction,Cancel" "$cnt of $# files." "Next: $i")
        if [ "cancelAction" == "$ACTION" ]; then
            status="canceled"
            break
        else
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
                    dunstify --appname="Extract w PW" --urgency=low --icon=dialog-information  "Failed $i with PW: $pass"
                else
                    status="success"
                    break
                fi
            done <"$PASSWORDS"
            if [[ $status = "fail" ]]; then
                failf+="$i "
                (( failc++ )) || true
            fi
        fi
	done
fi
dunstify -C $msgid
if [[ $status = "canceled" ]]; then
    dunstify --appname="Extract w PW" --urgency=low --icon=dialog-information "Canceled"
else
    dunstify --appname="Extract w PW" --urgency=low --icon=dialog-information "Finished extraction of $cnt files. Failed: $failc"
fi
# ) 2>&1 | tee -a /home/alexander/test.log
