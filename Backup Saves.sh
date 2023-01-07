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
CHECKED_ROM_DIRS=()
#Directories that will be skipped regardless if they have files in it.
SKIPPED_DIRS=("$BACKUP_DIR" "backup" "opt" "themes" "etc" "bezels" "bios" "BGM" "bgmusic" "launchimages" "screenshots" "tools" "videos")  
TMP_FILE="/tmp/romdirectories.txt"
ROMS2="/roms2/"
#########################

FindGameDir () {
 
printf "Finding ROM directories...\n"
ls -d1 /roms2/*/ > "$TMP_FILE" #Only shows parent rom directories.
while read -r line; do
    line=$(cut -c 8- <<< "$line") #Removes the '/roms2/' from the array items.
    ROM_DIRS+=("$line")
done < $TMP_FILE 

for log in ${ROM_DIRS[@]}; do
    if [ -z "$(ls -A $ROMS2/$log)" ]; then #Skips directory if it's empty.
        continue
    fi
    CHECKED_ROM_DIRS+=("$log") #This array only stores the names of the directories that aren't empty. 
done
}

PruneGameDir () { #This function removes any folders that are meant to be skipped.
for skipped in ${SKIPPED_DIRS[@]}; do
    for fol in ${CHECKED_ROM_DIRS[@]}; do
        if [ "$fol" == "$skipped/" ]; then
        CHECKED_ROM_DIRS=( "${CHECKED_ROM_DIRS[@]/$fol}" )
        fi
    done
done
unset ROM_DIRS
}

CreateBackupDirs () {
for fol in ${CHECKED_ROM_DIRS[@]}; do
    if [ ! -d "/roms2/$BACKUP_DIR/$fol" ]; then
        sudo mkdir -v /roms2/"$BACKUP_DIR"/"$fol"; printf "\n"
    fi
done    
}

BackUpSaves () {
printf "\e[0mBacking up save files...\n"
for dir in ${CHECKED_ROM_DIRS[@]}; do
    if [ $dir == "dreamcast/" ]; then
        sudo find /roms2/"$dir" -name "*.bin" -exec cp {} /roms2/"$BACKUP_DIR"/"$dir" \;
    fi
    for svfile in ${SAVE_TYPES[@]}; do 
        printf "Finding $svfile files and copying them to $BACKUP_DIR/$dir...\n"
        sudo find /roms2/"$dir" -name "*.$svfile" -exec cp {} /roms2/"$BACKUP_DIR"/"$dir" \;
    done
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
    FindGameDir
    PruneGameDir
    CreateBackupDirs
    BackUpSaves
else
    BackupWarning
fi
}

BackupWarning () {
dialog --title "Warning" --yesno "This will overwrite any saves in the $BACKUP_DIR folder. \n Do you want to continue?\n" $height $width
if [ $? = 0 ]; then
    FindGameDir
    PruneGameDir
    CreateBackupDirs
    BackUpSaves
elif [ $? = 1 ]; then
    printf "No action taken. Exiting Script..."
    sleep 2
    KillControls 
    exit 1
fi
}

main () {
StartBackupFunction
KillControls
}

main

exit 0