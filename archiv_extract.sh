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
#msgid=0
canceled="false"
status="none"

if  dir=$(kdialog --getexistingdirectory "$defdir"); then
    dbusRef=$(kdialog --title "Extract w PW" \
        --progressbar "$cnt of $# files. Next: $i" $#)
    qdbus $dbusRef showCancelButton true
    for i in "$@"; do
        qdbus $dbusRef Set "" value $cnt
        qdbus $dbusRef setLabelText "$cnt of $# files. Next: $i"
        (( cnt++ )) || true
#        ACTION=$(notify-send.py "$cnt of $# files. Next: $i" \
#                            --app-name "Extract w PW" \
#                            --urgency low \
#                            --icon dialog-information \
#                            --action cancelAction:Cancel \
#                            --replaces-id "$msgid" )
#        if [ "$msgid" -eq 0 ]; then
#            msgid="${ACTION#*$'\n'}"
#        fi
#        if [ "cancelAction" == "${ACTION:0:12}" ]; then
#            status="canceled"
#            break
#        else
        canceled=$(qdbus $dbusRef wasCancelled)
        if [[ "$canceled" == "true" ]]; then
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
                    kdialog --title "Extract w PW" --passivepopup \
                        "Failed $i with PW: $pass" 10
#                    notify-send.py "Failed $i with PW: $pass" \
#                                    --app-name "Extract w PW" \
#                                    --urgency low \
#                                    --icon dialog-information \
#                                    --replaces-id "$msgid"
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
#    fi
    done
    qdbus $dbusRef close
else
    status="canceled"
fi
if [[ $status = "canceled" ]]; then
    kdialog --title "Extract w PW" --passivepopup \
        "Canceled. Already extracted $cnt archives. Failed: $failc" 10
#    notify-send.py "Canceled. Already extracted $cnt archives. Failed: $failc" \
#                    --app-name "Extract w PW" \
#                    --urgency low \
#                    --icon dialog-information \
#                    --replaces-id "$msgid"
else
    kdialog --title "Extract w PW" --passivepopup \
        "Finished extraction of $cnt archives. Failed: $failc" 10
#    notify-send.py "Finished extraction of $cnt archives. Failed: $failc" \
#                    --app-name "Extract w PW" \
#                    --urgency low \
#                    --icon dialog-information \
#                    --replaces-id "$msgid"
fi
