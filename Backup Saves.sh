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
sudo $CONTROLS Backup\ Saves.sh rg552 & sleep 2

#########################
SAVE_TYPES=("srm" "state*" "sav" "mcd")
BACKUP_DIR=${1:-"backupsavs"} #BACKUP FOLDER
#########################

BackUpSaves () {
printf "\e[0mBacking up save files...\n"

for svfile in ${SAVE_TYPES[@]}; do #creates subdirectories for each file type. 
    if [ "$svfile" == 'state*' ]; then
        if [ ! -d "/roms2/$BACKUP_DIR/state" ]; then
            printf "\n"
            sudo mkdir -v /roms2/$BACKUP_DIR/state
        fi
        printf "\nFinding $svfile files and copying them to $BACKUP_DIR/state..."
        sudo find /roms2 -not -path */$BACKUP_DIR/* -name "*.$svfile" -exec cp {} /roms2/$BACKUP_DIR/state \;
        continue
    elif [ ! -d "/roms2/$BACKUP_DIR/$svfile" ]; then
        printf "\n"
        sudo mkdir -v /roms2/"$BACKUP_DIR"/"$svfile"
    fi
printf "\nFinding $svfile files and copying them to $BACKUP_DIR/$svfile..."
sudo find /roms2 -not -path */$BACKUP_DIR/* -name "*.$svfile" -exec cp {} /roms2/$BACKUP_DIR/"$svfile" \;
done

printf "\n\n\e[32mYour saves have been backed up"
sleep 2
}

KillControls () { #Needs to be run before the script exits. Without this it will cause the device's controls to be wonky until next restart. 
pgrep -f oga_controls | sudo xargs kill -9
}

StartBackupFunction () {
if [ ! -d "/roms2/$BACKUP_DIR" ]; then
    printf "\n"
    sudo mkdir -v /roms2/"$BACKUP_DIR"
    BackUpSaves
else
    BackupWarning
fi
}

BackupWarning () {
dialog --title "Warning" --yesno "This will overwrite any saves in the $BACKUP_DIR folder. \n Do you want to continue?\n" $height $width
if [ $? = 0 ]; then
    BackUpSaves
elif [ $? = 1 ]; then
    printf "No action taken. Exiting Script..."
    sleep 2
    KillControls
    printf "\033c" > /dev/tty1
    exit 1
fi
}

StartBackupFunction
KillControls
printf "\033c" > /dev/tty1

exit 0