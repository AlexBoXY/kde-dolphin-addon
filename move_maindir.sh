#!/bin/bash
dir="$1/"
ext=$(kdialog --checklist "Select File-Extension(s):" 1 "*.mkv" on 2 "*.avi" off 3 "*.mp4" off)
rcExt=$?
if [[ $rcExt == 0 ]]; then
	for i in $ext; do
		+kdialog --msgbox $i
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
