#!/bin/bash

#Script to check to see if there are save files. Then backs them up. 
#Created by TheExcitedTech

sudo chmod 666 /dev/tty1
printf "\e[?25l" > /dev/tty1 #hide cursor
dialog --clear

height="15" 
width="55"

printf "\033c" > /dev/tty1
printf "Starting Save Backup Script..." > /dev/tty1

CONTROLS="/opt/wifi/oga_controls"
sudo $CONTROLS Backup\ Saves.sh rg552 & sleep 2 #Joystick controls

#########################
SAVE_TYPES=("srm" "state*" "sav" "mcd" "eep" "mpk" "st0")
BACKUP_DIR=${1:-"backupsavs"} #BACKUP FOLDER
ROM_DIRS=()
TMP_FILE="/tmp/romdirectories.txt"
#########################

FindGameDir () {

####Iterate through ROM_DIRS
####If there is content in ROM_DIRS, create directory in $BACKUP_DIR and look for $SAVE_TYPES in the directory to backup 
####This will make it easier to organize the save data by system
#### Write the function in a way that checks for the directories in roms2. So if there is custom systems/collections this will also backup their saves. Keep this versatile and scalable. 

ls -d1 /roms2 > "$TMP_FILE" #Only shows parent rom directories.
while read -r line; do
    ROM_DIRS+=("$line\n")
done < $TMP_FILE 

for log in ${ROM_DIRS[@]}; do
        if [ "$(ls -A "/roms2/$log")"  ]; then
            mkdir "/roms2/$BACKUP_DIR/$log"
            
        else
        continue
        fi

done
    #while read temp file line by line - add each to an array(ROM_DIRS)
    #Loop through directories and check if there is content in there
    #If there is content, check if there is any SAVE_TYPES and create folder in BACKUPDIR with ROM_DIRS name and copy SAVE_TYPES in there
    #rm temporary file  

}
BackUpSaves () {
printf "\e[0mBacking up save files...\n"

for svfile in ${SAVE_TYPES[@]}; do #creates subdirectories for each file type. 
    if [ "$svfile" == 'state*' ]; then
        if [ ! -d "/roms2/$BACKUP_DIR/state" ]; then
            printf "\n"
            sudo mkdir -v /roms2/$BACKUP_DIR/state
        fi
        printf "Finding $svfile files and copying them to $BACKUP_DIR/state...\n"
        sudo find /roms2 -not -path */$BACKUP_DIR/* -name "*.$svfile" -exec cp {} /roms2/$BACKUP_DIR/state \;
        continue
    elif [ ! -d "/roms2/$BACKUP_DIR/$svfile" ]; then
        printf "\n"
        sudo mkdir -v /roms2/"$BACKUP_DIR"/"$svfile"
    fi
printf "Finding $svfile files and copying them to $BACKUP_DIR/$svfile...\n"
sudo find /roms2 -not -path */$BACKUP_DIR/* -name "*.$svfile" -exec cp {} /roms2/$BACKUP_DIR/"$svfile" \;
done

printf "\n\n\e[32mYour saves have been backed up"
sleep 2
}

KillControls () { 
pgrep -f oga_controls | sudo xargs kill -9 #Needs to be run before the script exits.
printf "\033c" > /dev/tty1
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
    exit 1
fi
}

StartBackupFunction
KillControls
exit 0