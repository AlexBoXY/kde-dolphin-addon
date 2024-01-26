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
msgid=0
status="none"
if  dir=$(kdialog --getexistingdirectory "$defdir"); then
    for i in "$@"; do
        (( cnt++ )) || true
        ACTION=$(notify-send.py "$cnt of $# files. Next: $i" \
                            --app-name "Extract w PW" \
                            --urgency low \
                            --icon dialog-information \
                            --action cancelAction:Cancel \
                            --replaces-id $msgid )
        if [ "$MSGID" -gt 0 ]; then
            MSGID="${ACTION#*$'\n'}"
        fi
        if [ "cancelAction" == "${ACTION:0:12}" ]; then
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
                    notify-send.py "Failed $i with PW: $pass" \
                                    --app-name "Extract w PW" \
                                    --urgency low \
                                    --icon dialog-information \
                                    --replaces-id $msgid
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
if [[ $status = "canceled" ]]; then
    notify-send.py "Canceled" \
                    --app-name "Extract w PW" \
                    --urgency low \
                    --icon dialog-information \
                    --replaces-id $msgid
else
    notify-send.py "Finished extraction of $cnt files. Failed: $failc" \
                    --app-name "Extract w PW" \
                    --urgency low \
                    --icon dialog-information \
                    --replaces-id $msgid
fi
