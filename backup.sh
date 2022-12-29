#!/bin/bash

#Script to check to see if there are Save files. Then backs them up. 
#LOG_FILE='/roms2/backupsavs/backupsavs.log'
clear
printf "\e[31mThis will overwrite any saves in the backupsav\n"
sleep 3
printf "\e[0mBacking up save files...\n"

SAVE_TYPES=("srm" "state*" "sav" "mcd")

if [ ! -d "roms2/backupsavs" ]; then
    sudo mkdir -v /roms2/backupsavs
fi

for svfile in ${SAVE_TYPES[@]}; do #creates subdirectories for each file type. 
    if [ $svfile == 'state*' ]; then #I don't think * will play nice with folder name. 
        if [ ! -d "/roms2/backupsavs/state" ]; then
            sudo mkdir -v /roms2/backupsavs/state
        fi
        sudo find /roms2 -name "*.$svfile" -exec cp -t /roms2/backupsavs/state {} \;
    elif [ ! -d "roms2/backupsavs/$svfile" ]; then
        sudo mkdir -v /roms2/backupsavs/$svfile
    fi
printf "\n\nFinding $svfile files and copying them to backupsavs..."
sudo find /roms2 -name "*.$svfile" -exec cp -t /roms2/backupsavs/$svfile {} \;
done

 printf "\n\n\e[32mYour saves gave been backed up"

sleep 3
exit 0