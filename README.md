# Retro Saves Backup Script
## Bash script that will find save and state files and copy them up to a backups directory.

Designed around the 353V Device with ArkOS. The filepaths are hardcoded to look for roms2/

Default parent folder is 'backupsavs'

Argument can be passed that will change the parent folder to whatever you put in the argument for that instance of the script being run. 

You can also change the default directory by editing the `BACKUP_DIR` variable.

**Please make sure to offload the backupsavs folder to another location, such as a cloud storage location.**
-------

Dev Branch is to mess with the script to add experimental features. Will merge into main branch when changes have been tested and functionally verified. We should never code directly in PROD

*Dev Branch can/will probably break the script. Be careful with using the script in the dev branch.*

Dev Branch has support for organizing the backups by system folder in the $BACKUP_DIR. 
