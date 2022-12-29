#!/bin/bash

#Script to check to see if there are Save files. Then backs them up. 
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

# export TERM=linux
# export XDG_RUNTIME_DIR=/run/user/$UID/

printf "\033c" > /dev/tty1
printf "Starting Backup Save Script..." > /dev/tty1

#
# Joystick controls
#
# only one instance
CONTROLS="/opt/wifi/oga_controls"
sudo $CONTROLS backup.sh rg552 &
sleep 2


dialog --title "Warning" --yesno "This will overwrite any saves in the backupsav. \n Do you want to continue?" 10 40
if [ $? = 0 ]; then
    BackUpSaves
elif [ $? = 1 ]; then
    printf "No action taken. Exiting Script..."
    pgrep -f oga_controls | sudo xargs kill -9
    exit 1
else
    printf "Unable to recognize choice. Exiting Script..."
    pgrep -f oga_controls | sudo xargs kill -9
    exit 2
fi

SAVE_TYPES=("srm" "state*" "sav" "mcd")

#printf "\e[31mThis will overwrite any saves in the backupsav\n"
BackUpSaves{
printf "\e[0mBacking up save files...\n"

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

 printf "\n\n\e[32mYour saves have been backed up"

sleep 3
}

pgrep -f oga_controls | sudo xargs kill -9
exit 0