#/bin/bash
clear
#Script to check to see if there are .sav files. Then backs them up. 
#LOG_FILE='/roms2/backupsavs/backupsavs.log'

if [ ! -d "roms2/backupsavs" ]; then
    sudo mkdir -v /roms2/backupsavs
    sudo mkdir -v /roms2/backupsavs/states
fi

printf "\n\nFinding .sav files and copying them to backupsavs..."
sudo find /roms2 -name '*.srm' -exec cp -t /roms2/backupsavs/ {} \;
printf "\n\nFinding .state files and copying them to backupsavs..."
sudo find /roms2 -name '*.state*' -exec cp -t /roms2/backupsavs/states/ {} \;
printf "\n\n\e[32mThe backup has been completed"
sleep 5

exit 0