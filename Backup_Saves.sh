#!/bin/bash

#Script to check to see if there are save files. Then backs them up. 
#Created by TheExcitedTech

#LOG_FILE='/roms2/backupsavs/backupsavs.log'
sudo chmod 666 /dev/tty1
printf "\033c" > /dev/tty1

# hide cursor
printf "\e[?25l" > /dev/tty1
dialog --clear

height="15"
width="55"

if test ! -z "$(cat /home/ark/.config/.DEVICE | grep RG503 | tr -d '\0')"
then
  height="20"
  width="60"
fi

printf "\033c" > /dev/tty1
printf "Starting Save Backup Script..." > /dev/tty1

# Joystick controls
# only one instance
CONTROLS="/opt/wifi/oga_controls"
sudo $CONTROLS Backup_Saves.sh rg552 & sleep 2

#########################
SAVE_TYPES=("srm" "state*" "sav" "mcd")
BACKUPFOLDER="backupsavs"
#########################

BackUpSaves () {
printf "\e[0mBacking up save files...\n"

for svfile in ${SAVE_TYPES[@]}; do #creates subdirectories for each file type. 
    if [ $svfile == 'state*' ]; then
        if [ ! -d "/roms2/$BACKUPFOLDER/state" ]; then
            sudo mkdir -v /roms2/$BACKUPFOLDER/state
        fi
        sudo find /roms2 -not -path */$BACKUPFOLDER/* -name "*.$svfile" -exec cp {} /roms2/$BACKUPFOLDER/state \;
    elif [ ! -d "/roms2/$BACKUPFOLDER/$svfile" ]; then
        sudo mkdir -v /roms2/$BACKUPFOLDER/$svfile
    fi
printf "\n\nFinding $svfile files and copying them to $BACKUPFOLDER..."
sudo find /roms2 -not -path */$BACKUPFOLDER/* -name "*.$svfile" -exec cp {} /roms2/$BACKUPFOLDER/$svfile \;
done

printf "\n\n\e[32mYour saves have been backed up"
sleep 2
}


StartBackupFunction () {
if [ ! -d "/roms2/$BACKUPFOLDER" ]; then
    sudo mkdir -v /roms2/$BACKUPFOLDER
    BackUpSaves
    pgrep -f oga_controls | sudo xargs kill -9
else
    BackupWarning
fi
}

BackupWarning () {
dialog --title "Warning" --yesno "This will overwrite any saves in the $BACKUPFOLDER folder. \n Do you want to continue?\nNote:If you don't have a $BACKUPFOLDER folder this will create it." $height $width
if [ $? = 0 ]; then
    BackUpSaves
    pgrep -f oga_controls | sudo xargs kill -9
elif [ $? = 1 ]; then
    printf "No action taken. Exiting Script..."
    sleep 2
    pgrep -f oga_controls | sudo xargs kill -9
    exit 1
fi
}

StartBackupFunction
clear

exit 0