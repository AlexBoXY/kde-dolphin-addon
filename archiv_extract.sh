#!/bin/bash
# Author AlexBoXY
# licened under GPLv3
where=$(dirname "$@")
cd "$where"
# Passwords must be in file ~/.config/archiv_extract.pass  (one password per line)
PASSWORDS="$HOME/.config/archiv_extract.pass"
dir=$(kdialog --getexistingdirectory ~/);
if [[ $? == 0 ]]; then
	for i in $@; do
		kdialog --title "Extract w PW" --passivepopup "$i"
		status="fail"
		while read -r pass; do
			if [[ $i == *".rar" ]]; then
				unrar -y -p"$pass" x "$i" "$dir"
				rc=$?
			else
				7z -y -p"$pass" -o"$dir" x "$i"
				rc=$?
			fi
			if [[ $rc != 0 ]]; then
				status="fail"
				kdialog --title "Extract w PW" --passivepopup "Failed $i with PW: $pass"
			else
				status="success"
				kdialog --title "Extract w PW" --passivepopup "Success $i with PW: $pass"
				break
			fi
		done <$PASSWORDS
	done
fi
kdialog  --title "Extract w PW" --passivepopup "Finished extraction"
