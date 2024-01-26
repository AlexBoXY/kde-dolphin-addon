# kde-dolphin-addon
Addons for Dolphin ServiceMenu

## archiv_extract
Extract selected archives using passwords from file to choosen directory.
So it's more conviniend than Dolphins integrated ARK menu entries.
Depends on: kdialog, notify-send.py, unrar, p7zip.

### Installation:
* Place archiv_extract.sh in your ~/.local/bin directory. Make it executable.
* Place archiv_extract.desktop in your ~/.local/share/kservices5/ServiceMenus directory.
* Place archiv_extract.pass in your ~/.config directory. Customize the file to your needs (one password per line).
* Place archiv_extract.conf in your ~/.config directory. Set default directory.

## move_mainDir
Moves files from subdirectories matching choosen extension into current directory.
Depends on kdialog, notify-send.py and find.

### Installation:
* Place move_mainDir.sh in your ~/.local/bin directory. Make it executable.
* Place move_mainDir.desktop in your ~/.local/share/kservices5/ServiceMenus directory.
* Place move_mainDir.conf in your ~/.config directory. Customize the file to your needs (one file type per line eg. .txt No trailing NewLine! ).
