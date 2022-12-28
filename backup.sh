#/bin/bash
clear
#Script to check to see if there are .sav files. Then backs them up. 
#LOG_FILE='/roms2/backupsavs/backupsavs.log'
SAVE_TYPES=(".srm" ".state*" ".sav")

if [ ! -d "roms2/backupsavs" ]; then
    sudo mkdir -v /roms2/backupsavs
fi

for svfile in ${SAVE_TYPES[@]}; do #creates subdirectories for each file type. 
    if [ ! -d "roms2/backupsavs/@svfile" ]; then
    sudo mkdir -v /roms2/backupsavs/@svfile
    fi
printf "\n\nFinding @svfile files and copying them to backupsavs..."
sudo find /roms2 -name "*@svfile" -exec cp -t /roms2/backupsavs/@svfile {} \;
done


# printf "\n\nFinding @svfile files and copying them to backupsavs..."  Isn't needed with the for loop.
# sudo find /roms2 -name '*.srm' -exec cp -t /roms2/backupsavs/ {} \;
# printf "\n\nFinding .state files and copying them to backupsavs..."
# sudo find /roms2 -name '*.state*' -exec cp -t /roms2/backupsavs/states/ {} \;
# printf "\n\n\e[32mThe backup has been completed"
sleep 5

exit 0