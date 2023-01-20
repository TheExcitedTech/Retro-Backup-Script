# Retro Saves Backup Script
## Bash script that will find save and state files and copy them up to a backups directory.

Designed around the 353V Device with ArkOS.
It uses OGA_Controls to allow it to be ran on a few devices. Might need to change the controls line if running on different hardware. 

Reference https://github.com/christianhaitian/oga_controls

------

The script will check to see if there is content in the parent ROMs directory. If there is at least 1 file, it will create a folder in the `$BACKUP_DIR` with the folder title and scan the directory to see if there are any save files to backup.  

Default backup parent folder is 'backupsavs'. 
Default root directory is '/roms2'

You can change the default backup parent directory by changing the `BACKUP_DIR` variable.
You can change the default root directory by changing the `ROOT_DIR` variable. 

There is an array `$SKIPPED_DIRS` for folders that will be automatically skipped regardless if there is content in it or not. These are meant to include system folders.

Argument can be passed that will change the parent folder to the argument for that instance of the script being run. 
You can pass a second argument to change the $ROOT directory. 
This is useful if you are running the script through an SSH tunnel or using a keyboard.

Changing the paths are useful if you plan on using the script on another device or only have 1 SD card.

**Please make sure to offload the `$BACKUP_DIR` folder to another place, such as a cloud storage location.**
------

Dev Branch is to mess with the script to add experimental features. Will merge into main branch when changes have been tested and functionally verified. We should never code directly in PROD

*Dev Branch can/will probably break the script. Be careful with using the script in the dev branch.*
